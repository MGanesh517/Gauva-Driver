# API Performance Optimization Guide

## What Was Fixed

### 1. ✅ Token Caching (CRITICAL FIX)
**Problem**: Token was fetched from secure storage on EVERY API request (async operation).
**Impact**: Adds ~10-50ms delay per request.

**Solution**: 
- Token is now cached in memory for 30 minutes
- Cache is automatically cleared when token is saved/cleared
- Reduces token fetch overhead to near zero after first request

### 2. ✅ API Response Time Measurement
**Added**: Automatic timing logs for all API requests
**Output**: 
```
⏱️ API Response Time: 1234ms | GET /dashboard
⚠️ SLOW API: /dashboard took 2500ms (>2s)
```

### 3. ✅ Optimized Timeouts
**Before**: 
- sendTimeout: 60s
- receiveTimeout: 60s
- connectTimeout: 30s

**After**:
- sendTimeout: 30s (fail faster if slow)
- receiveTimeout: 30s (fail faster if slow)
- connectTimeout: 15s (fail faster on connection issues)

### 4. ✅ Conditional Logger
**Before**: PrettyDioLogger enabled in all builds
**After**: Only enabled in debug mode (disabled in release builds)
**Impact**: Better production performance

### 5. ✅ HTTP Keep-Alive
**Added**: Persistent connections enabled
**Impact**: Reuses connections, faster subsequent requests

## How to Measure API Response Time

### Option 1: Automatic (Already Implemented)
All API calls are automatically timed. Check console logs:
```
⏱️ API Response Time: 1234ms | GET /dashboard
```

### Option 2: Manual Measurement (For Specific Calls)
Use `ApiTimingUtil` for detailed measurement:

```dart
import 'package:gauva_driver/core/utils/api_timing_util.dart';

// In your service method
Future<Response> getDashboard() async {
  return await ApiTimingUtil.measure(
    name: 'Get Dashboard',
    apiCall: () => dioClient.dio.get(ApiEndpoints.dashboard),
  );
}
```

### Option 3: Compare with Expected Time
```dart
final isFast = await ApiTimingUtil.measureAndCompare(
  name: 'Get Dashboard',
  apiCall: () => dioClient.dio.get(ApiEndpoints.dashboard),
  expectedMaxMs: 1000, // Should complete in <1s
);
```

## How to Identify the Problem

### Step 1: Check API Response Time Logs
Look for these patterns in console:

1. **Fast (<500ms)**: ✅ Good - Backend is fast
   ```
   ⏱️ API Response Time: 234ms | GET /dashboard
   ```

2. **Moderate (500-2000ms)**: ⚠️ Acceptable but could be better
   ```
   ⏱️ API Response Time: 1200ms | GET /dashboard
   🐌 API took 1200ms (>1s) - Consider optimization
   ```

3. **Slow (>2000ms)**: ❌ Problem - Backend/DB issue
   ```
   ⏱️ API Response Time: 3500ms | GET /dashboard
   ⚠️ SLOW API: /dashboard took 3500ms (>2s)
   ```

### Step 2: Compare Flutter Time vs Backend Time

**If Flutter log shows 3000ms but Postman shows 500ms:**
→ Network/Flutter issue (unlikely with these fixes)

**If Both Flutter and Postman show 3000ms:**
→ Backend/DB issue (most likely)

### Step 3: Check Which Endpoints Are Slow
Look for patterns:
- Are all endpoints slow? → Backend/DB connection issue
- Is only one endpoint slow? → That endpoint has a problem (missing index, N+1 query, etc.)

## Common Issues and Solutions

### Issue: First API call is very slow (5-20s), then fast
**Cause**: Azure App Service cold start
**Solution**: 
- Enable "Always On" in Azure Portal → App Service → Configuration
- Add a warm-up endpoint that gets called periodically

### Issue: All API calls are consistently slow (>2s)
**Possible Causes**:
1. **Database Connection Pool Exhausted**
   - Check Spring Boot `application.properties`:
   ```properties
   spring.datasource.hikari.maximum-pool-size=15
   spring.datasource.hikari.minimum-idle=5
   ```

2. **PostgreSQL Region Mismatch**
   - Ensure PostgreSQL is in the SAME Azure region as App Service
   - Different region = 200-500ms extra latency per query

3. **N+1 Query Problem**
   - Check for loops that make DB calls
   - Use JOIN FETCH in JPA queries

4. **Missing Indexes**
   - Check slow queries in PostgreSQL logs
   - Add indexes on WHERE, JOIN, ORDER BY columns

### Issue: Flutter log shows fast (<500ms) but UI feels slow
**Possible Causes**:
1. **Large JSON Response**
   - Check response size
   - Use DTOs instead of full entities
   - Enable pagination

2. **JSON Parsing on Main Thread**
   - ✅ Already fixed: Using `FlutterComputeTransformer` (parsing in isolate)

3. **Multiple API Calls**
   - Check if same API is called multiple times
   - Cache responses where appropriate

## Quick Checklist

✅ **Flutter Side** (What we fixed):
- [x] Token caching (no storage read per request)
- [x] Response time measurement (automatic logs)
- [x] Optimized timeouts
- [x] Conditional logger (disabled in release)
- [x] HTTP keep-alive enabled
- [x] JSON parsing in background isolate

❓ **Backend Side** (What you need to check):
- [ ] Azure "Always On" enabled
- [ ] PostgreSQL in same region as App Service
- [ ] HikariCP connection pool tuned
- [ ] Database indexes added
- [ ] No N+1 queries
- [ ] GZIP compression enabled
- [ ] Response DTOs (not full entities)

## Example: Using Timing in Your Services

```dart
// Before (no timing)
Future<Response> getDashboard() async {
  return await dioClient.dio.get(ApiEndpoints.dashboard);
}

// After (with timing)
Future<Response> getDashboard() async {
  return await ApiTimingUtil.measure(
    name: 'Get Dashboard',
    apiCall: () => dioClient.dio.get(ApiEndpoints.dashboard),
  );
}
```

## Next Steps

1. **Run the app** and check console logs for API response times
2. **Compare** Flutter timing with Postman timing
3. **Identify** slow endpoints (>2s)
4. **Check** Azure Portal metrics (CPU, Memory, Response Time)
5. **Optimize** backend based on findings

## Questions?

If you see:
- **Fast in Postman, slow in Flutter**: Check Flutter network setup
- **Slow in both**: Backend/DB issue (check Spring Boot logs, PostgreSQL slow queries)
- **First call slow, rest fast**: Azure cold start (enable Always On)


#!/usr/bin/env pwsh

# Script to replace all hardcoded 'Inter' font references with GoogleFonts.inter()

$files = @(
    "lib\presentation\dashboard\widgets\navigation_card.dart",
    "lib\presentation\auth\widgets\auth_bottom_buttons.dart",
    "lib\presentation\auth\views\signup_page.dart",
    "lib\core\utils\exit_app_dialogue.dart",
    "lib\core\utils\delete_account_dialogue.dart"
)

foreach ($file in $files) {
    $fullPath = "c:\Users\lapto\Downloads\Driver Flutter App Full SourceCode\Driver Flutter App Full SourceCode\$file"
    
    if (Test-Path $fullPath) {
        Write-Host "Processing: $file"
        
        # Read content
        $content = Get-Content $fullPath -Raw
        
        # Add import if not present
        if ($content -notmatch 'import.*google_fonts') {
            $content = $content -replace '(import.*material\.dart.*\n)', "`$1import 'package:google_fonts/google_fonts.dart';`n"
        }
        
        # Replace fontFamily: 'Inter' with GoogleFonts.inter()
        # This is a simple replacement - may need manual adjustment for complex cases
        $content = $content -replace "fontFamily: 'Inter',", "// fontFamily: 'Inter', // Replaced with GoogleFonts.inter()"
        
        # Write back
        Set-Content $fullPath $content -NoNewline
        
        Write-Host "✓ Updated: $file"
    } else {
        Write-Host "✗ Not found: $file"
    }
}

Write-Host "`nDone! Please review the changes and manually update TextStyle to GoogleFonts.inter() where needed."

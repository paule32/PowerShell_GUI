# ----------------------------------------------------------------------------
# @file   settings.ps1
# @author (c) 2025 by paule32 - Jens Kallup
#         all rights reserved.
#
# @brief  This file is part of the HelpNDoc.com Tools.
# ----------------------------------------------------------------------------

# ----------------------------------------------------------------------------
# Setzt die ExecutionPolicy nur für den aktuellen Prozess – notwendig, 
# falls das Skript durch die Standardrichtlinien blockiert wird.
# ----------------------------------------------------------------------------
Set-ExecutionPolicy -Scope Process -ExecutionPolicy Bypass

Add-Type -AssemblyName System.Windows.Forms
Add-Type -AssemblyName System.Drawing

# ----------------------------------------------------------------------------
# globale default Variablen ...
# ----------------------------------------------------------------------------
$locale = ""    # localization
$style  = ""    # application style
$timer1 = $null
$tab_control = $null
# ----------------------------------------------------------------------------
# \brief Konstanten für Formular Komponenten für Create(<component>)
# ----------------------------------------------------------------------------
$Form_Form       =  1
$Form_Panel      =  2
$Form_Button     =  3   # Create -> Button
$Form_Label      =  4   # Create -> Label
$Form_Font       =  5
$Form_MenuBar    =  6
$Form_MenuItem   =  7
$Form_TabControl =  8
$Form_TabPage    =  9
$Form_Timer      = 10

# ----------------------------------------------------------------------------
# \brief Konstanten für Formular Komponenten für Drawing(<component>)
# ----------------------------------------------------------------------------
$Draw_Font       =  1
$Draw_Size       =  2
$Draw_Point      =  3

# ----------------------------------------------------------------------------
# \brief  This function is used to create alias names for new object refers.
# \param  nothing
# \return nothing - act as procedure
# \author paule32
# ----------------------------------------------------------------------------
function Import-FormsTypes {
    Set-Variable -Name Application         -Value ([System.Windows.Forms.Application])         -Scope Script
    Set-Variable -Name Form                -Value ([System.Windows.Forms.Form])                -Scope Script
    Set-Variable -Name DockStyle           -Value ([System.Windows.Forms.DockStyle])           -Scope Script
    Set-Variable -Name MenuBar             -Value ([System.Windows.Forms.MenuStrip])           -Scope Script
    Set-Variable -Name MenuItem            -Value ([System.Windows.Forms.ToolStripMenuItem])   -Scope Script
    Set-Variable -Name ToolStripRenderMode -Value ([System.Windows.Forms.ToolStripRenderMode]) -Scope Script
    Set-Variable -Name MessageBox          -Value ([System.Windows.Forms.MessageBox])          -Scope Script
    Set-Variable -Name TabControl          -Value ([System.Windows.Forms.TabControl])          -Scope Script
    Set-Variable -Name TabPage             -Value ([System.Windows.Forms.TabPage])             -Scope Script
    Set-Variable -Name Label               -Value ([System.Windows.Forms.Label])               -Scope Script
    Set-Variable -Name Panel               -Value ([System.Windows.Forms.Panel])               -Scope Script
    Set-Variable -Name Button              -Value ([System.Windows.Forms.Button])              -Scope Script
    Set-Variable -Name Timer               -Value ([System.Windows.Forms.Timer])               -Scope Script
    Set-Variable -Name Point               -Value ([System.Drawing.Point])                     -Scope Script
    Set-Variable -Name Size                -Value ([System.Drawing.Size])                      -Scope Script
    Set-Variable -Name Color               -Value ([System.Drawing.Color])                     -Scope Script
    Set-Variable -Name Font                -Value ([System.Drawing.Font])                      -Scope Script
    Set-Variable -Name FontStyle           -Value ([System.Drawing.FontStyle])                 -Scope Script
    Set-Variable -Name CultureInfo         -Value ([System.Globalization.CultureInfo])         -Scope Script
}
# ----------------------------------------------------------------------------
# HTML-Farbcodes oder bekannte Namen -> übersetzen
# ----------------------------------------------------------------------------
function get_json_color {
    param (
        $objectColor = ""
    )
    $result = switch ($objectColor.ToLower()) {
        "black"  { $Color::Black  }
        "white"  { $Color::White  }
        "blue"   { $Color::Blue   }
        "yellow" { $Color::Yellow }
        "green"  { $Color::Green  }
        "red"    { $Color::Red    }
        default  { $Color::Lime   }
    }
    return $result
}
# ----------------------------------------------------------------------------
# \brief  This function is a short workaround for mimic oop programming.
# \param  $arg1 = int -> object Type
# \return $referenz   -> New.Object from $arg
# \author paule32
# ----------------------------------------------------------------------------
function Create {
    param ( $arg1 = $null  )
    $result = switch ($arg1) {
        $Form_Form       { return New-Object $Form       }
        $Form_Panel      { return New-Object $Panel      }
        $Form_Button     { return New-Object $Button     }
        $Form_Label      { return New-Object $Label      }
        $Form_MenuBar    { return New-Object $MenuBar    }
        $Form_MenuItem   { return New-Object $MenuItem   }
        $Form_TabControl { return New-Object $TabControl }
        $Form_TabPage    { return New-Object $TabPage    }
        $Form_Font       { return New-Object $Font       }
        $Form_Timer      { return New-Object $Timer      }
        default          {
            Write-Host "Error: unknown Create type: $arg1"
            exit
        }
    }
    return $result
}
# ----------------------------------------------------------------------------
# \brief  This function is a workaround to mimic oo programming. It is used to
#         check the arguments that was given for a bunch of functions, and tp
#         save storage resource and cpu time power.
# \param  $arg1 - a string for the output message
# \param  $argn - misc.
# ----------------------------------------------------------------------------
function argCheck {
    param ( $arg1, $arg2, $arg3 )
    if ($null -eq $arg1) {
        Write-Host "$arg1 argument 1 = null."
        exit
    }   elseif ($null -eq $arg2) {
        Write-Host "$arg1 argument 2 = null."
        exit
    }   elseif ($null -eq $arg3) {
        Write-Host "$arg1 argument 3 = null."
        exit
    }
}
# ----------------------------------------------------------------------------
# \brief  This function is a short workaround for mimic oop programming.
# \param  $arg1 - int -> xpos
# \param  $arg2 - int -> ypos
# \return $referenz   -> Drawing.Point
# \author paule32
# ----------------------------------------------------------------------------
function TPoint {
    param ( $arg1, $arg2 )
    argCheck "TPoint" $arg1 $arg2
    return New-Object $Point($arg1, $arg2)
}
function TSize {
    param ( $arg1, $arg2 )
    argCheck "TSize" $arg1 $arg2
    return New-Object $Size($arg1, $arg2)
}
function TForm {
    param ( $arg1, $arg2 )
    argCheck "TForm" $arg1 $arg2
    $frm = Create($Form_Form)
    if ($null -eq $form) {
        Write-Host "TForm konnte nicht erzeugt werden."
        exit
    }
    $frm.Size = TSize $arg1 $arg2
    $frm.StartPosition = "CenterScreen"
    return $frm
}
function TFont {
    param ( $arg1, $arg2, $arg3 )
    argCheck "TFont" $arg1 $arg2 $arg3
    return New-Object $Font($arg1, $arg2, $arg3)
}
function TTimer {
    param ( $arg1 )
    argCheck "TTimer" $arg1 ""
    $res = Create($Form_Timer)
    $res.Interval = $arg1
    return $res
}
# ----------------------------------------------------------------------------
# START INITIALIZATION ...
# ----------------------------------------------------------------------------
function ApplicationInitialize {
    $langCode = $CultureInfo::CurrentUICulture.TwoLetterISOLanguageName

    # ------------------------------------------------------------------------
    # Fallback auf Englisch, falls Sprache nicht vorhanden
    # ------------------------------------------------------------------------
    $supportedLangs = @("de", "en")
    if ($supportedLangs -notcontains $langCode) {
        $langCode = "en"
    }
    # ------------------------------------------------------------------------
    # JSON-Datei laden (locales)
    # ------------------------------------------------------------------------
    $langFile = Join-Path -Path $PSScriptRoot -ChildPath "lang\$langCode.json"
    if (-Not (Test-Path $langFile)) {
        Write-Host "Language file not found: $langFile"
        exit
    }
    $locale = Get-Content $langFile -Raw | ConvertFrom-Json

    # ------------------------------------------------------------------------
    # JSON-Datei laden (locales)
    # ------------------------------------------------------------------------
    $ThemeStyle = "light"
    $styleFile = Join-Path -Path $PSScriptRoot -ChildPath "style\$ThemeStyle.json"
    if (-Not (Test-Path $langFile)) {
        Write-Host "Style file not found: $styleFile"
        exit
    }
    $style = Get-Content $styleFile -Raw | ConvertFrom-Json

    # ------------------------------------------------------------------------
    # Farben aus JSON vorbereiten
    # ------------------------------------------------------------------------
    $css_normal            = $style.Menu.Normal
    $css_hover             = $style.Menu.Hover
    $normal_color_menubar  = $css_normal.Brush.Color
    $normal_color_text     = $css_normal.Font.Color
    $hover_Color           = $style.Menu.Hover.Brush.Color

    # ------------------------------------------------------------------------
    # 1) Eigene Renderer-Klasse definieren (via Add-Type mit C#)
    # ------------------------------------------------------------------------
    $source = @"
    using System.Drawing;
    using System.Windows.Forms;

    public class CustomMenuRenderer : ToolStripProfessionalRenderer
    {
        public Color BackgroundColor    = Color.Blue;
        public Color TextColor          = Color.White;
        public float TextFontSize       = 10f;
        
        public float HoverTextFontSize  = 10f;
        public Color HoverColor         = Color.DarkBlue;
        public Color HoverTextColor     = Color.Yellow;

        protected override void OnRenderToolStripBackground(ToolStripRenderEventArgs e) {
            using (SolidBrush brush = new SolidBrush(BackgroundColor)) {
                e.Graphics.FillRectangle(brush, e.AffectedBounds);
            }
        }

        protected override void OnRenderMenuItemBackground(ToolStripItemRenderEventArgs e) {
            Color bg = e.Item.Selected ? HoverColor : BackgroundColor;
            using (SolidBrush brush = new SolidBrush(bg)) {
                e.Graphics.FillRectangle(brush, new System.Drawing.Rectangle(
                System.Drawing.Point.Empty, e.Item.Size));
            }
        }

        protected override void OnRenderItemText(ToolStripItemTextRenderEventArgs e) {
            if (e.Item.Selected) {
                e.TextColor = HoverTextColor;
                e.Item.Font = new Font("Arial", HoverTextFontSize, FontStyle.Bold);
            }   else {
                e.TextColor = TextColor;
                e.Item.Font = new Font("Arial", TextFontSize, FontStyle.Bold);
            }
            base.OnRenderItemText(e);
        }
    }
"@
    Add-Type -TypeDefinition $source -ReferencedAssemblies 'System.Windows.Forms.dll','System.Drawing.dll'

    $menubar_renderer = New-Object CustomMenuRenderer
    $menubar_renderer.BackgroundColor    = get_json_color($css_normal.Brush.Color)
    $menubar_renderer.TextColor          = get_json_color($css_normal.Font.Color)
    #$menubar_renderer.TextFontSize      =                $css_normal.Font.Size
    #$menubar_renderer.HoverTextColor    = get_json_color($css_hover.Font.Color)
    #$menubar_renderer.HoverTextFontSize =                $css_hover.Font.Size
    
    return $locale, $style, $menubar_renderer
}

# ----------------------------------------------------------------------------
# START GUI ... Fenster erstellen
# ----------------------------------------------------------------------------
function InitializeUI {
    param ( $locale )
    argCheck "InitUI" $locale ""
    
    $frm = TForm 320 200
    $frm.Text = $locale.rs_windowTitle

    # ----------------------------------------------------------------------------
    # Panel hinter dem MenuStrip
    # ----------------------------------------------------------------------------
    $menupanel = Create($Form_Panel)
    argCheck "FormPanel" $menupanel ""
    $menupanel.Dock = $DockStyle::Top
    $menupanel.Height = 24  # Höhe des MenuStrip ungefähr

    $frm.Controls.Add($menupanel)
    
    # ----------------------------------------------------------------------------
    # Event Handler ...
    # ----------------------------------------------------------------------------
    $frm.Add_Shown({
        $frm.ResumeLayout($true)    
        $frm.PerformLayout()
        $frm.Refresh()
        
        $frm.Invalidate()
        $frm.Update()
        
        $frm.Width  += 1
        $frm.Height += 1
        $frm.Width  -= 1
        $frm.Height -= 1

        # ------------------------------------------------------------------------
        # Timer zum "Klick simulieren"
        # wir setzen denselben Tab erneut
        # ------------------------------------------------------------------------
        $global:timer1 = TTimer 1000
        if ($null -eq $global:timer1) {
            Write-Host "ee --- ee"
        }
        $global:timer1.Add_Tick({
            #$frm.BeginInvoke({
            Write-Host "Aktualisiert"
            #})
        })
        $global:timer1.Start()
    })
    $frm.Add_FormClosing({
        if ($null -ne $global:timer1) {
            Write-Host "Form wird geschlossen – Timer1 wird gestoppt."
            $global:timer1.Stop()
            $global:timer1.Dispose()
        }
    })
    return $frm, $menupanel
}
function initalizeMenu {
    param ( $frm, $pan )
    argCheck "initMenu" $frm $pan
    # ----------------------------------------------------------------------------
    # Schriftart definieren (z.B. Arial, 10pt, Fett)
    # ----------------------------------------------------------------------------
    $font_css  = $style.Menu.Normal.Font.Style
    $fontname  = $style.Menu.Normal.Font.Name
    $fontsize  = [float]$style.Menu.Normal.Font.Size
    $fontstyle = $FontStyle::Regular

    if ($font_css.Bold      -eq 1) { $fontstyle = $fontstyle -bor $FontStyle::Bold }
    if ($font_css.Italic    -eq 1) { $fontstyle = $fontstyle -bor $FontStyle::Italic }
    if ($font_css.Underline -eq 1) { $fontstyle = $fontstyle -bor $FontStyle::Underline }
    Write-Host "Name: $fontname, Size: $fontsize, Style: $fontstyle"

    $menuFont = TFont $fontname $fontsize $fontstyle

    # ----------------------------------------------------------------------------
    # Menüleiste erstellen
    # Abstand von 5 Pixeln zum oberen Rand
    # ----------------------------------------------------------------------------
    $menuStrip = Create($Form_MenuBar)
    $menuStrip.Renderer = $menubar_renderer
    $menuStrip.Location = TPoint 0 5

    # ----------------------------------------------------------------------------
    # RenderMode auf Professional setzen, damit BackColor übernommen wird
    # ----------------------------------------------------------------------------
    #$menuStrip.RenderMode = $ToolStripRenderMode::Professional

    # ----------------------------------------------------------------------------
    # "Datei"-Menü
    # ----------------------------------------------------------------------------
    $fileMenu = Create($Form_MenuItem)
    $fileMenu.Text = $locale.rs_menu_file
    $fileMenu.Font = TFont $fontname $fontsize $fontstyle

    # ----------------------------------------------------------------------------
    # "Hilfe"-Menü
    # ----------------------------------------------------------------------------
    $helpMenu = Create($Form_MenuItem)
    $helpMenu.Text = $locale.rs_menu_help
    $helpMenu.Font = TFont $fontname $fontsize $fontstyle

    $aboutItem = Create($Form_MenuItem)
    $aboutItem.Text = $locale.rs_menu_help_about
    $aboutItem.Font = TFont $fontname $fontsize $fontstyle
    
    $aboutItem.Add_Click({
        $box = Create($Form_Form)
        $box.Text = "About..."
        $box.Size = TSize 242 180
        $box.StartPosition = "CenterScreen"
        
        $box_lbl1 = Create($Form_Label)
        $box_lbl1.Text = "HelpNDoc.com 9.9 Tools"
        $Box_lbl1.Size = TSize 200 14
        $box_lbl1.Location = TPoint 42 10
        
        $box_lbl2 = Create($Form_Label)
        $box_lbl2.Text = "Version 0.0.1 by Jens Kallup"
        $Box_lbl2.Size = TSize 200 14
        $box_lbl2.Location = TPoint 32 26
        
        $box_lbl3 = Create($Form_Label)
        $box_lbl3.Text = "All rights reserved."
        $Box_lbl3.Size = TSize 200 14
        $box_lbl3.Location = TPoint 64 42
        
        $box_btn1 = Create($Form_Button)
        $box_btn1.Text = "Close"
        $box_btn1.Size = TSize 84 34
        $box_btn1.Location = TPoint 64 70
        
        $box.Controls.Add($box_lbl1)
        $box.Controls.Add($box_lbl2)
        $box.Controls.Add($box_lbl3)
        
        $box.Controls.Add($box_btn1)
        
        $box_btn1.Add_Click({
            $box.Close()
        })
        
        $box.ShowDialog()
    })

    # ----------------------------------------------------------------------------
    # "Beenden"-Eintrag
    # ----------------------------------------------------------------------------
    $exitItem = Create($Form_MenuItem)
    $exitItem.Text = $locale.rs_menu_file_exit
    $exitItem.Font = TFont $fontname $fontsize $fontstyle
    
    $exitItem.Add_Click({
        $frm.Close()
    })

    # ----------------------------------------------------------------------------
    # Beenden zum Datei-Menü hinzufügen
    # ----------------------------------------------------------------------------
    $fileMenu.DropDownItems.Add($exitItem)
    $helpMenu.DropDownItems.Add($aboutItem)

    # ----------------------------------------------------------------------------
    # -Menüs zur Menüleiste hinzufügen
    # ----------------------------------------------------------------------------
    $menuStrip.Items.Add($fileMenu)
    $menuStrip.Items.Add($helpMenu)

    # ----------------------------------------------------------------------------
    # Menüleiste zum Formular hinzufügen
    # ----------------------------------------------------------------------------
    $frm.MainMenuStrip = $menuStrip
    $pan.Controls.Add($menuStrip)
}
function initTabs {
    param ( $frm )
    argCheck "initTabs" $frm ""
    
    # ----------------------------------------------------------------------------
    # Container-Panel für Tabs (mit Padding)
    # ----------------------------------------------------------------------------
    $tabPanel = Create($Form_Panel)
    $tabPanel.Dock = "Fill"
    $tabPanel.Padding = New-Object System.Windows.Forms.Padding(5,25,5,5)
    $tabPanel.BackColor = "Control"  # gleiche Farbe wie Form

    # ----------------------------------------------------------------------------
    # TabControl hinzufügen
    # ----------------------------------------------------------------------------
    $tab_control = Create($Form_TabControl)
    $tab_control.Dock = "Fill"

    # ----------------------------------------------------------------------------
    # Allgemein - Tab 1
    # ----------------------------------------------------------------------------
    $tab_common = Create($Form_TabPage)
    $tab_common.Text = "rs_tab_common_text"
    $tab_common_label1 = Create($Form_Label)
    $tab_common_label1.Text = "Dies ist Tab 1"
    $tab_common_label1.Location = TPoint 20 20
    $tab_common.Controls.Add($tab_common_label1)

    # ----------------------------------------------------------------------------
    # Erweitert - Tab 2
    # ----------------------------------------------------------------------------
    $tab_advance = Create($Form_TabPage)
    $tab_advance.Text = "Erweitert"
    $tab_advance_label2 = Create($Form_Label)
    $tab_advance_label2.Text = "Dies ist Tab 2"
    $tab_advance_label2.Location = TPoint 20 20
    $tab_advance.Controls.Add($tab_advance_label2)

    # ----------------------------------------------------------------------------
    # Tabs hinzufügen
    # ----------------------------------------------------------------------------
    $tab_control.TabPages.Add($tab_common)
    $tab_control.TabPages.Add($tab_advance)

    # ----------------------------------------------------------------------------
    # TabControl dem Panel hinzufügen
    # ----------------------------------------------------------------------------
    $tabPanel.Controls.Add($tab_control)

    # ----------------------------------------------------------------------------
    # TabControl dem Formular hinzufügen
    # ----------------------------------------------------------------------------
    $frm.Controls.Add($tabPanel)
    
    return $tab_control
}
# ----------------------------------------------------------------------------
# Button hinzufügen
# ----------------------------------------------------------------------------
function testButton {
    param ( $tab )
    
    $button1 = Create($Form_Button)
    $button1.Text = "Klick mich"
    $button1.Size = TSize 100 40
    $button1.Location = TPoint 100 60

    # Klick-Handler
    $button1.Add_Click({
        $box = Create($Form_Form)
        $box.Size = TSize 400 400
        $box.StartPosition = "CenterScreen"
        $box.ShowDialog()
    })
    
    $tab.Controls.Add($button1)
    return $tab
}

# ----------------------------------------------------------------------------
# script entry point ...
# ----------------------------------------------------------------------------
function scriptMain {
    Import-FormsTypes
    
    $locale, $style, $menubar_renderer = ApplicationInitialize
    $frm, $menupanel = InitializeUI $locale
    $menubar = initalizeMenu $frm $menupanel
    $tab_control = initTabs $frm
    
    $dstTab = $tab_control.TabPages[0]  # index begint bei 0
    $btn1 = testButton $dstTab
    
    # ----------------------------------------------------------------------------
    # Fenster anzeigen
    # ----------------------------------------------------------------------------
    $frm.Show()

    # ----------------------------------------------------------------------------
    # Event-Loop starten (non-blocked)
    # ----------------------------------------------------------------------------
    while ($frm.Visible) {
        $Application::DoEvents()
        $frm.ResumeLayout($true)    
        $frm.PerformLayout()
        $frm.Refresh()
        Start-Sleep -Milliseconds 200
    }
}

scriptMain

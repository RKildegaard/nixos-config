use adw::prelude::*;
use anyhow::Result;
use adw::{Application, PreferencesPage, PreferencesGroup, EntryRow, SpinRow, PreferencesWindow};
use gio::glib;
use std::{fs, path::PathBuf, process::Command};

#[derive(serde::Serialize, serde::Deserialize, Clone)]
struct Settings {
    appearance: Appearance,
    display: Display,
    keyboard: Keyboard,
}
#[derive(serde::Serialize, serde::Deserialize, Clone)]
struct Appearance {
    cursor: Cursor,
    font: Font,
}
#[derive(serde::Serialize, serde::Deserialize, Clone)]
struct Cursor { name: String, size: u32 }
#[derive(serde::Serialize, serde::Deserialize, Clone)]
struct Font { monospace: String, terminalSize: u32 }
#[derive(serde::Serialize, serde::Deserialize, Clone)]
struct Display { monitors: Vec<Monitor> }
#[derive(serde::Serialize, serde::Deserialize, Clone)]
struct Monitor { name: String, scale: f32 }
#[derive(serde::Serialize, serde::Deserialize, Clone)]
struct Keyboard { layout: String }

fn settings_path() -> PathBuf {
    // adjust if your repo root differs
    PathBuf::from("/etc/nixos/settings/settings.json")
}

fn load() -> Result<Settings> {
    let s = fs::read_to_string(settings_path())?;
    Ok(serde_json::from_str(&s)?)
}

fn save(s: &Settings) -> Result<()> {
    let tmp = settings_path().with_extension("json.tmp");
    fs::write(&tmp, serde_json::to_string_pretty(s)? + "\n")?;
    fs::rename(tmp, settings_path())?;
    Ok(())
}

fn apply_rebuild(target: &str) {
    // escalate; customize if you prefer a systemd service instead of pkexec
    let _ = Command::new("pkexec")
        .arg("nixos-rebuild")
        .arg("switch").arg("--flake")
        .arg(format!("/etc/nixos#{}", target))
        .spawn();
}

fn main() -> glib::ExitCode {
    let app = Application::builder()
        .application_id("dk.raskil.Settings")
        .build();

    app.connect_activate(|app| {
        let css = include_str!("../../../../home/raskil/files/settings-ui/style.css");
        let provider = gtk4::CssProvider::new();
        provider.load_from_data(css.as_bytes());
        gtk4::style_context_add_provider_for_display(
            &gtk4::gdk::Display::default().unwrap(),
            &provider,
            gtk4::STYLE_PROVIDER_PRIORITY_USER,
        );

        let mut data = load().expect("load settings.json");
        let win = PreferencesWindow::builder()
            .title("System Settings")
            .default_width(800)
            .default_height(600)
            .transient_for(&gtk4::ApplicationWindow::NONE)
            .build();
        win.set_application(Some(app));

        // Appearance
        let page_app = PreferencesPage::builder().title("Appearance").icon_name("preferences-desktop-theme").build();

        let group_cursor = PreferencesGroup::builder().title("Cursor").build();
        let cursor_name = EntryRow::builder().title("Cursor theme").build();
        cursor_name.set_text(&data.appearance.cursor.name);
        let cursor_size = SpinRow::builder().title("Cursor size").adjustment(&gtk4::Adjustment::new(data.appearance.cursor.size as f64, 8.0, 128.0, 1.0, 5.0, 0.0)).build();
        group_cursor.add(&cursor_name);
        group_cursor.add(&cursor_size);

        let group_font = PreferencesGroup::builder().title("Terminal Font").build();
        let font_mono = EntryRow::builder().title("Monospace font").build();
        font_mono.set_text(&data.appearance.font.monospace);
        let font_size = SpinRow::builder().title("Terminal font size").adjustment(&gtk4::Adjustment::new(data.appearance.font.terminalSize as f64, 8.0, 64.0, 1.0, 5.0, 0.0)).build();
        group_font.add(&font_mono);
        group_font.add(&font_size);

        page_app.add(&group_cursor);
        page_app.add(&group_font);

        // Display
        let page_disp = PreferencesPage::builder().title("Display").icon_name("video-display").build();
        let group_mon = PreferencesGroup::builder().title("Primary monitor").build();
        let mon = data.display.monitors.get(0).cloned().unwrap_or(Monitor { name: "eDP-1".into(), scale: 1.0 });
        let mon_name = EntryRow::builder().title("Name").build();
        mon_name.set_text(&mon.name);
        let mon_scale = SpinRow::builder().title("Scale").digits(2).adjustment(&gtk4::Adjustment::new(mon.scale as f64, 1.0, 3.0, 0.05, 0.1, 0.0)).build();
        group_mon.add(&mon_name);
        group_mon.add(&mon_scale);
        page_disp.add(&group_mon);

        // Keyboard
        let page_kbd = PreferencesPage::builder().title("Keyboard").icon_name("input-keyboard").build();
        let group_kbd = PreferencesGroup::builder().title("Layout").build();
        let kb_layout = EntryRow::builder().title("XKB layout").build();
        kb_layout.set_text(&data.keyboard.layout);
        group_kbd.add(&kb_layout);
        page_kbd.add(&group_kbd);

        // Apply button
        let apply_btn = gtk4::Button::with_label("Apply");
        apply_btn.add_css_class("suggested-action");
        apply_btn.connect_clicked(glib::clone!(@strong win, @strong cursor_name, @strong cursor_size, @strong font_mono, @strong font_size, @strong mon_name, @strong mon_scale, @strong kb_layout => move |_| {
            // write back
            let mut s = load().unwrap_or(data.clone());
            s.appearance.cursor.name = cursor_name.text().to_string();
            s.appearance.cursor.size = cursor_size.value() as u32;
            s.appearance.font.monospace = font_mono.text().to_string();
            s.appearance.font.terminalSize = font_size.value() as u32;
            if let Some(m0) = s.display.monitors.get_mut(0) {
                m0.name = mon_name.text().to_string();
                m0.scale = mon_scale.value() as f32;
            }
            s.keyboard.layout = kb_layout.text().to_string();

            if let Err(e) = save(&s) {
                eprintln!("save error: {e}");
                return;
            }

            // optionally commit so flakes pick it up deterministically
            let _ = Command::new("git").args(["-C","/etc/nixos","add","settings/settings.json"]).status();
            let _ = Command::new("git").args(["-C","/etc/nixos","commit","-m","Update settings via GUI"]).status();

            apply_rebuild("laptop");
        }));

        let header = win.titlebar();
        if let Some(h) = header {
            if let Some(hb) = h.downcast_ref::<adw::HeaderBar>() {
                hb.pack_end(&apply_btn);
            }
        }

        win.add(&page_app);
        win.add(&page_disp);
        win.add(&page_kbd);
        win.present();
    });

    app.run()
}


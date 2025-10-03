use adw::prelude::*;
use adw::Application;
use gtk4 as gtk;
use gtk::{gio, glib};


fn main() -> glib::ExitCode {
    let app = Application::builder()
        .application_id("dk.raskil.Settings")
        .build();

    app.connect_activate(|app| {
        // (only if you're loading CSS)
        let provider = gtk::CssProvider::new();
        gtk::style_context_add_provider_for_display(
            &gtk::gdk::Display::default().unwrap(),
            &provider,
            gtk::STYLE_PROVIDER_PRIORITY_USER,
        );

        let win = adw::PreferencesWindow::builder()
            .title("System Settings")
            .default_width(800)
            .default_height(600)
            .build();
        win.set_application(Some(app));
        win.present();
    });

    app.run()
}


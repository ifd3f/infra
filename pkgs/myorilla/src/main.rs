use orilla::prelude::*;

fn main() {
    let tags: Vec<char> = "1234567890".chars().collect();
    let wm = orilla::Orilla::new()
        .tags(tags.iter().map(|&t| t.to_string()).collect())
        .layouts(layout_set![Tall::default(), Full])
        .wrap(Gaps::with(4))
        .borders(
            Borders::new(2, "#9e9e9e80")
                .focused("#008080e6")
                .urgent((3, "#ff0000")),
        )
        .keys(
            vec![
                Keybinding::new(Mods::Super, 'm', action::focus_primary()),
                Keybinding::new(Mods::Super, 'j', action::focus_next()),
                Keybinding::new(Mods::Super, 'k', action::focus_prev()),
                Keybinding::new(Mods::Super, keysyms::Return, action::promote()),
                Keybinding::new(Mods::Super | Mods::Shift, 'j', action::swap_next()),
                Keybinding::new(Mods::Super | Mods::Shift, 'k', action::swap_prev()),
                // TODO: these were in the template but appear to be broken. what were they cooking?
                // Keybinding::new(Mods::Super | Mods::Alt, 'n', action::next_tag()),
                // Keybinding::new(Mods::Super | Mods::Alt, 'e', action::prev_tag()),
                Keybinding::new(Mods::Super | Mods::Shift, 'c', action::close()),
                Keybinding::new(Mods::Super, keysyms::space, action::cycle_layout()),
                Keybinding::new(Mods::Super, 't', action::spawn("fuzzel")),
                Keybinding::new(Mods::Super, keysyms::Return, action::spawn("foot")),
                // Bindings related to the 'Tall' layout
                Keybinding::new(
                    Mods::Super,
                    keysyms::comma,
                    action::message(Tall::IncMainCount),
                ),
                Keybinding::new(
                    Mods::Super,
                    keysyms::period,
                    action::message(Tall::DecMainCount),
                ),
                Keybinding::new(Mods::Super, 'h', action::message(Tall::ShrinkMain)),
                Keybinding::new(Mods::Super, 'l', action::message(Tall::GrowMain)),
            ]
            .into_iter()
            .chain(
                tags.iter()
                    .map(|&t| Keybinding::new(Mods::Super, t, action::switch_tag(t.to_string()))),
            )
            .chain(tags.iter().map(|&t| {
                Keybinding::new(
                    Mods::Super | Mods::Shift,
                    t,
                    action::shift_tag(t.to_string()),
                )
            }))
            .collect(),
        );

    if let Err(e) = wm.run() {
        eprintln!("orilla-config-template failed: {e}");
        std::process::exit(1);
    }
}

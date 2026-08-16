use orilla::prelude::*;
use xkeysym::Keysym;

mod keys;

/// Tags (workspaces) associated with the key used to select them
struct TagInfo {
    pub name: String,
    pub key: Keysym,
}

fn main() {
    let tags: Vec<TagInfo> = "1234567890"
        .chars()
        .map(|c| TagInfo {
            name: c.to_string(),
            key: Keysym::from_char(c)
        })
        .collect();

    let documented_keys = keys::make_keybindings(&tags).collect::<Vec<_>>();
    // TODO: split out the documentation and make a help dialog
    let keys_vec = documented_keys
        .into_iter()
        .map(|k| k.binding)
        .collect::<Vec<_>>();

    let wm = orilla::Orilla::new()
        .tags(tags.into_iter().map(|t| t.name).collect())
        .layouts(layout_set![Tall::default(), Full])
        .wrap(Gaps::with(4))
        .borders(
            Borders::new(2, "#9e9e9e80")
                .focused("#008080e6")
                .urgent((3, "#ff0000")),
        )
        .keys(keys_vec);

    if let Err(e) = wm.run() {
        eprintln!("myorilla failed: {e}");
        std::process::exit(1);
    }
}

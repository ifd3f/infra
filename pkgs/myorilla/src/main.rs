use orilla::prelude::*;
use tracing_subscriber::EnvFilter;
use xkeysym::Keysym;

mod keys;

/// Tags (workspaces) associated with the key used to select them
struct TagInfo {
    pub name: String,
    pub key: Keysym,
}

fn main() {
    setup_logging();

    let tags: Vec<TagInfo> = "1234567890"
        .chars()
        .map(|c| TagInfo {
            name: c.to_string(),
            key: Keysym::from_char(c),
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
        tracing::error!("myorilla failed: {e}");
        std::process::exit(1);
    }
}

fn setup_logging() {
    tracing_subscriber::fmt()
        .with_env_filter(EnvFilter::from_default_env())
        .with_ansi(false)
        .with_writer(std::io::stderr)
        .init();
}

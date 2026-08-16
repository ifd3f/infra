use orilla::{actions::IntoKeybindingAction, prelude::*};
use xkeysym::Keysym;

use crate::TagInfo;

pub fn make_keybindings<'a>(
    tags: &'a [TagInfo],
) -> impl Iterator<Item = DocumentedKeybinding> + 'a {
    let prev = Keysym::k;
    let next = Keysym::j;
    let primary = Keysym::Return;

    let window_management: Vec<DocumentedKeybinding> = vec![
        gk(Mods::Super | Mods::Shift, Keysym::q, action::close()),
        // focus
        gk(Mods::Super | Mods::Ctrl, primary, action::focus_primary()),
        gk(Mods::Super, next, action::focus_next()),
        gk(Mods::Super, prev, action::focus_prev()),
        // movement
        gk(Mods::Super | Mods::Shift, next, action::swap_next()),
        gk(Mods::Super | Mods::Shift, prev, action::swap_prev()),
        gk(
            Mods::Super | Mods::Ctrl | Mods::Shift,
            primary,
            action::promote(),
        ),
        // layout
        gk(Mods::Super, Keysym::space, action::cycle_layout()),
    ];

    let quick_launch: Vec<DocumentedKeybinding> = vec![
        dk(
            Mods::Super,
            Keysym::Return,
            action::spawn("wezterm"),
            "Spawn terminal",
        ),
        dk(
            Mods::Super,
            Keysym::d,
            action::spawn("fuzzel"),
            "Open quick launcher",
        ),
    ];

    // Bindings related to the 'Tall' layout
    let tall_layout: Vec<DocumentedKeybinding> = vec![
        dk(
            Mods::Super,
            Keysym::comma,
            action::message(Tall::IncMainCount),
            "(tall layout) Add window to main column",
        ),
        dk(
            Mods::Super,
            Keysym::period,
            action::message(Tall::DecMainCount),
            "(tall layout) Remove window from main column",
        ),
        dk(
            Mods::Super,
            Keysym::h,
            action::message(Tall::ShrinkMain),
            "(tall layout) Expand main window width",
        ),
        dk(
            Mods::Super,
            Keysym::l,
            action::message(Tall::GrowMain),
            "(tall layout) Shrink main window width",
        ),
    ];

    let switch_tags: Vec<DocumentedKeybinding> = tags
        .iter()
        .map(|t| {
            gk(
                Mods::Super,
                t.key.clone(),
                action::switch_tag(t.name.clone()),
            )
        })
        .collect();

    let shift_tags: Vec<DocumentedKeybinding> = tags
        .iter()
        .map(|t| {
            gk(
                Mods::Super | Mods::Shift,
                t.key,
                action::shift_tag(t.name.clone()),
            )
        })
        .collect();

    [
        window_management,
        quick_launch,
        tall_layout,
        switch_tags,
        shift_tags,
    ]
    .into_iter()
    .flatten()
}

/// Helper that wraps [`Keybinding::new`] followed by [`KeybindingExt::guess_docs`].
fn gk(mods: Mods, keysym: Keysym, action: impl IntoKeybindingAction) -> DocumentedKeybinding {
    Keybinding::new(mods, keysym.raw(), action).guess_docs()
}

/// Helper that wraps [`DocumentedKeybinding`] and [`Keybinding::new`] constructors.
fn dk(
    mods: Mods,
    keysym: Keysym,
    action: impl IntoKeybindingAction,
    doc: impl ToString,
) -> DocumentedKeybinding {
    DocumentedKeybinding {
        binding: Keybinding::new(mods, keysym.raw(), action),
        doc: doc.to_string(),
    }
}

pub struct DocumentedKeybinding {
    pub binding: Keybinding,
    pub doc: String,
}

trait KeybindingExt {
    /// Guess the documentation for this keybinding based on the action.
    ///
    /// This is an extremely stupid function and cannot accurately guess values
    /// that are type-erased, like layout messages, closures, and other things like that.
    fn guess_docs(self) -> DocumentedKeybinding;
}

impl KeybindingExt for Keybinding {
    fn guess_docs(self) -> DocumentedKeybinding {
        generate_default_docs(self)
    }
}

fn generate_default_docs(binding: Keybinding) -> DocumentedKeybinding {
    let doc: String = match &binding.action {
        orilla::KeybindingAction::Action(a) => match a {
            Action::LayoutMessage(_) => {
                "TODO: cannot guess this action! Reconfigure the layout in some manner or another"
                    .into()
            }
            Action::Window(a) => match a {
                orilla::WindowAction::Close => "Close focused window",
                orilla::WindowAction::FocusPrimary => "Focus primary window",
                orilla::WindowAction::FocusNext => "Focus next window",
                orilla::WindowAction::FocusPrev => "Focus previous window",
                orilla::WindowAction::Promote => "Promote focused window to primary",
                orilla::WindowAction::SwapNext => "Swap focused window with next",
                orilla::WindowAction::SwapPrev => "Swap focused window with previous",
            }
            .into(),
            Action::Spawn(items) => format!("Run command {items:?}"),
            Action::CycleLayout => "Cycle layouts".into(),
            Action::Tag(a) => match a {
                orilla::TagAction::Switch(t) => format!("Switch to tag {t}"),
                orilla::TagAction::Toggle(t) => format!("Toggle tag {t}"),

                // TODO: confirm what the fuck this does
                orilla::TagAction::Shift(t) => format!("Move window to tag {t}"),
            },
        },
        orilla::KeybindingAction::Closure(_) => {
            "TODO: cannot guess this action! Execute closure".into()
        }
    };
    DocumentedKeybinding { binding, doc }
}

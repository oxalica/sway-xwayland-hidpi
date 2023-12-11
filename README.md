Port of patched xwayland and wlroots from AUR for HIDPI xwayland support.

See also: <https://gitlab.freedesktop.org/xorg/xserver/-/merge_requests/432>

Use `xprop -root -f _XWAYLAND_GLOBAL_OUTPUT_SCALE 32c -set _XWAYLAND_GLOBAL_OUTPUT_SCALE 2`
to set the global xwayland scaling factor. Note that fractional scaling is not supported.

Provides:
- `wlroots-hidpi-xprop`
  Port of [wlroots-hidpi-xprop-git](https://aur.archlinux.org/packages/wlroots-hidpi-xprop-git) from AUR.
- `xwayland-hidpi-xprop`
  Port of [xorg-xwayland-hidpi-xprop](https://aur.archlinux.org/packages/xorg-xwayland-hidpi-xprop) from AUR.
- `sway-unwrapped-xwayland-hidpi`
  A recent sway-git using the above dependencies.
- `sway-xwayland-hidpi`
  The former one wrapped.

### License

MIT Licensed.

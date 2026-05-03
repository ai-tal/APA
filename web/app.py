import os
from nicegui import ui, app as ngapp

BASE_DIR = os.path.dirname(os.path.dirname(os.path.abspath(__file__)))

VERSIONS = {
    "APAv01": {
        "label": "APA v1",
        "root": os.path.join(BASE_DIR, "APAv01"),
        "description": "Initial release — full plotting & processing library",
        "color": "blue",
    },
    "APA_v02": {
        "label": "APA v2",
        "root": BASE_DIR,
        "single_file": "APA_v02.m",
        "description": "Standalone monolithic app file",
        "color": "purple",
    },
    "APA_v03": {
        "label": "APA v3",
        "root": os.path.join(BASE_DIR, "APA_v03"),
        "description": "Extended I/O, regional masking, improved processing",
        "color": "green",
    },
}

NAMESPACE_COLORS = {
    "+io": ("blue-3", "blue-9"),
    "+plt": ("green-3", "green-9"),
    "+proc": ("orange-3", "orange-9"),
}


def get_file_tree(root: str, rel: str = "") -> list:
    nodes = []
    full = os.path.join(root, rel) if rel else root
    try:
        entries = sorted(os.listdir(full))
    except OSError:
        return nodes
    dirs = [e for e in entries if os.path.isdir(os.path.join(full, e)) and not e.startswith(".")]
    files = [e for e in entries if os.path.isfile(os.path.join(full, e)) and e.endswith(".m")]
    for d in dirs:
        child_rel = os.path.join(rel, d) if rel else d
        children = get_file_tree(root, child_rel)
        if children:
            nodes.append({"id": child_rel, "label": d, "children": children})
    for f in files:
        child_rel = os.path.join(rel, f) if rel else f
        nodes.append({"id": child_rel, "label": f})
    return nodes


def build_version_tree(ver_key: str) -> list:
    ver = VERSIONS[ver_key]
    if "single_file" in ver:
        sf = ver["single_file"]
        return [{"id": sf, "label": sf}]
    return get_file_tree(ver["root"])


def count_files(tree: list) -> int:
    count = 0
    for node in tree:
        if "children" in node:
            count += count_files(node["children"])
        else:
            count += 1
    return count


def load_file_content(ver_key: str, rel_path: str) -> tuple[str, int] | None:
    ver = VERSIONS[ver_key]
    if "single_file" in ver:
        if rel_path != ver["single_file"]:
            return None
        full_path = os.path.join(BASE_DIR, ver["single_file"])
    else:
        full_path = os.path.join(ver["root"], rel_path)
    full_path = os.path.realpath(full_path)
    if not full_path.startswith(os.path.realpath(BASE_DIR)):
        return None
    if not os.path.isfile(full_path):
        return None
    try:
        with open(full_path, encoding="utf-8") as f:
            content = f.read()
        return content, len(content.splitlines())
    except OSError:
        return None


def ns_badge(path: str) -> tuple[str, str] | None:
    for ns, colors in NAMESPACE_COLORS.items():
        if ns in path.replace("\\", "/"):
            labels = {"+io": "I/O", "+plt": "Plot", "+proc": "Proc"}
            return labels[ns], colors
    return None


@ui.page("/")
def main():
    ui.query("body").style("margin:0;padding:0;height:100vh;overflow:hidden;")
    ui.add_head_html("""
    <link rel="icon" href="data:image/svg+xml,<svg xmlns='http://www.w3.org/2000/svg' viewBox='0 0 100 100'><text y='.9em' font-size='90'>📡</text></svg>">
    <style>
      .q-tree__node-header { padding: 2px 4px !important; }
      .q-tree__node-header-content { font-size: 13px !important; }
      .nicegui-code { height: 100%; }
      .nicegui-code pre { border-radius: 0 !important; margin: 0 !important; }
      .code-scroll { flex: 1; overflow: auto; }
      pre.hljs { font-size: 13px !important; font-family: 'JetBrains Mono', 'Fira Code', monospace !important; }
    </style>
    """)

    state = {
        "version": "APAv01",
        "file_path": None,
        "trees": {k: build_version_tree(k) for k in VERSIONS},
        "counts": {},
    }
    for k, tree in state["trees"].items():
        state["counts"][k] = count_files(tree)

    current_tree_ref = {"obj": None}
    code_container_ref = {"obj": None}
    toolbar_ref = {"filename": None, "linecount": None, "badge": None}
    ver_info_ref = {"label": None, "desc": None, "count": None}
    welcome_ref = {"obj": None}
    viewer_ref = {"obj": None}

    with ui.column().classes("w-full h-screen no-wrap gap-0"):

        # ── Header ──────────────────────────────────────────────────────────
        with ui.row().classes("w-full items-center gap-3 px-4 py-2 bg-grey-10 no-wrap").style(
            "border-bottom:1px solid #30363d;flex-shrink:0;min-height:52px;"
        ):
            ui.label("📡").style("font-size:26px;line-height:1;")
            with ui.column().classes("gap-0"):
                ui.label("Antenna Pattern Analyzer").classes("text-white text-weight-bold").style("font-size:16px;")
                ui.label("MATLAB App Designer — Code Browser").classes("text-grey-5").style("font-size:11px;")
            ui.space()
            ui.badge("3 versions · 62 files", color="grey-8").classes("text-grey-4").style(
                "font-size:11px;border:1px solid #30363d;"
            )

        # ── Body ─────────────────────────────────────────────────────────────
        with ui.row().classes("w-full no-wrap gap-0").style("flex:1;overflow:hidden;"):

            # ── Sidebar ──────────────────────────────────────────────────────
            with ui.column().classes("gap-0").style(
                "width:280px;min-width:280px;background:#161b22;border-right:1px solid #30363d;"
                "display:flex;flex-direction:column;overflow:hidden;height:100%;"
            ):
                # Version tabs
                with ui.tabs(value=state["version"]).classes("w-full bg-grey-10").style(
                    "border-bottom:1px solid #30363d;flex-shrink:0;"
                ).props("dense align=justify") as version_tabs:
                    for k, v in VERSIONS.items():
                        ui.tab(k, label=v["label"])

                # File tree scroll area
                tree_scroll = ui.scroll_area().classes("w-full").style("flex:1;overflow:hidden auto;")
                with tree_scroll:
                    with ui.column().classes("w-full gap-0 p-2"):
                        current_tree_ref["obj"] = ui.tree(
                            state["trees"][state["version"]],
                            label_key="label",
                            node_key="id",
                        ).classes("w-full text-grey-3").props("dense dark")

                # Version info bar
                with ui.column().classes("px-3 py-2 gap-0").style(
                    "border-top:1px solid #30363d;background:#161b22;flex-shrink:0;"
                ):
                    ver_info_ref["label"] = ui.label(
                        VERSIONS[state["version"]]["label"]
                    ).classes("text-white text-weight-bold").style("font-size:12px;")
                    ver_info_ref["desc"] = ui.label(
                        VERSIONS[state["version"]]["description"]
                    ).classes("text-grey-5").style("font-size:11px;line-height:1.4;margin-top:2px;")
                    ver_info_ref["count"] = ui.label(
                        f"{state['counts'][state['version']]} source files"
                    ).classes("text-green-5").style("font-size:11px;margin-top:3px;")

            # ── Main content ─────────────────────────────────────────────────
            with ui.column().classes("gap-0").style(
                "flex:1;overflow:hidden;display:flex;flex-direction:column;background:#0d1117;"
            ):
                # Welcome screen
                welcome_ref["obj"] = ui.column().classes("w-full items-center justify-center gap-4 p-10").style(
                    "flex:1;text-align:center;"
                )
                with welcome_ref["obj"]:
                    ui.label("📡").style("font-size:60px;opacity:0.35;")
                    ui.label("Antenna Pattern Analyzer").classes("text-white text-weight-bold").style("font-size:22px;")
                    ui.label(
                        "A MATLAB App Designer application for loading, processing, and visualizing "
                        "antenna far-field radiation patterns from industry-standard simulation formats."
                    ).classes("text-grey-5").style("font-size:14px;max-width:500px;line-height:1.6;")
                    with ui.row().classes("gap-3 justify-center").style("max-width:640px;"):
                        for icon, title, desc in [
                            ("📂", "Multi-Format I/O", "Reads .fz, .ffd, .ffe, .ffs, .out from HFSS, GRASP, CST, FEKO, XGTD"),
                            ("📊", "Rich Plots", "Polar cuts, contour maps, 3-D spherical, filled polar, coverage masks"),
                            ("⚙️", "Pattern Processing", "Gain, EIRP, axial ratio, PLF, HPBW, polarisation, rotation, combine"),
                        ]:
                            with ui.card().classes("bg-grey-10 gap-1 text-left").style(
                                "border:1px solid #30363d;padding:14px;width:180px;"
                            ):
                                ui.label(icon).style("font-size:22px;")
                                ui.label(title).classes("text-white text-weight-bold").style("font-size:13px;")
                                ui.label(desc).classes("text-grey-5").style("font-size:12px;line-height:1.5;")
                    ui.label("Select a version and click any file in the sidebar to browse its source.").classes(
                        "text-grey-6"
                    ).style("font-size:13px;margin-top:8px;")

                # File viewer (hidden initially)
                viewer_ref["obj"] = ui.column().classes("gap-0").style(
                    "flex:1;overflow:hidden;display:none;flex-direction:column;"
                )
                with viewer_ref["obj"]:
                    # Toolbar
                    with ui.row().classes("w-full items-center px-3 py-2 gap-2 bg-grey-10 no-wrap").style(
                        "border-bottom:1px solid #30363d;flex-shrink:0;"
                    ):
                        toolbar_ref["badge"] = ui.badge("", color="blue-9").classes("text-blue-3").style(
                            "font-size:10px;"
                        )
                        toolbar_ref["filename"] = ui.label("").classes("text-white text-weight-medium").style(
                            "font-size:13px;flex:1;overflow:hidden;text-overflow:ellipsis;white-space:nowrap;"
                        )
                        toolbar_ref["linecount"] = ui.label("").classes("text-grey-5").style("font-size:11px;")
                        copy_btn = ui.button("Copy", icon="content_copy").props(
                            "flat dense size=sm color=grey-5"
                        )

                    code_container_ref["obj"] = ui.scroll_area().classes("w-full").style("flex:1;")

    # ── Handlers ─────────────────────────────────────────────────────────────

    def refresh_tree(ver_key: str):
        current_tree_ref["obj"].nodes = state["trees"][ver_key]
        current_tree_ref["obj"].update()
        ver = VERSIONS[ver_key]
        ver_info_ref["label"].set_text(ver["label"])
        ver_info_ref["desc"].set_text(ver["description"])
        ver_info_ref["count"].set_text(f"{state['counts'][ver_key]} source files")

    def open_file(event):
        node_id: str = event.value
        if not node_id:
            return
        # Check it's a leaf (file), not a directory
        def is_file_node(nodes, target):
            for n in nodes:
                if n["id"] == target:
                    return "children" not in n
                if "children" in n:
                    result = is_file_node(n["children"], target)
                    if result is not None:
                        return result
            return None

        ver_key = state["version"]
        if not is_file_node(state["trees"][ver_key], node_id):
            return

        result = load_file_content(ver_key, node_id)
        if result is None:
            return
        content, line_count = result
        filename = os.path.basename(node_id)
        state["file_path"] = node_id

        # Update toolbar
        badge_info = ns_badge(node_id)
        if badge_info:
            lbl, (fg, bg) = badge_info
            toolbar_ref["badge"].set_text(lbl)
            toolbar_ref["badge"].props(f"color={bg}")
            toolbar_ref["badge"].style(f"display:inline-flex;")
        else:
            toolbar_ref["badge"].style("display:none;")
        toolbar_ref["filename"].set_text(filename)
        toolbar_ref["linecount"].set_text(f"{line_count:,} lines")

        # Rebuild code view
        code_container_ref["obj"].clear()
        with code_container_ref["obj"]:
            ui.code(content, language="matlab").classes("w-full").style(
                "font-size:13px;font-family:'JetBrains Mono','Fira Code',monospace;"
            )

        # Copy handler needs current content
        copy_btn.on("click", lambda _, c=content: ui.run_javascript(
            f"navigator.clipboard.writeText({repr(c)})"
        ))

        # Show viewer, hide welcome
        welcome_ref["obj"].style("display:none;")
        viewer_ref["obj"].style("flex:1;overflow:hidden;display:flex;flex-direction:column;")

    def on_version_change(event):
        ver_key = event.value
        state["version"] = ver_key
        state["file_path"] = None
        refresh_tree(ver_key)
        # Return to welcome screen
        welcome_ref["obj"].style("flex:1;display:flex;")
        viewer_ref["obj"].style("display:none;")

    version_tabs.on_value_change(on_version_change)
    current_tree_ref["obj"].on("update:selected", open_file)


ui.run(
    host="0.0.0.0",
    port=5000,
    title="Antenna Pattern Analyzer",
    dark=True,
    reload=False,
    show=False,
    favicon="📡",
)

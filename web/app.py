from flask import Flask, render_template, jsonify, abort
import os
import json

app = Flask(__name__)

BASE_DIR = os.path.dirname(os.path.dirname(os.path.abspath(__file__)))

VERSIONS = {
    "APAv01": {
        "label": "APA v1",
        "root": os.path.join(BASE_DIR, "APAv01"),
        "description": "Initial version with full plotting and pattern processing library"
    },
    "APA_v02": {
        "label": "APA v2",
        "root": BASE_DIR,
        "files": ["APA_v02.m"],
        "description": "Standalone monolithic app file (v2 variant)"
    },
    "APA_v03": {
        "label": "APA v3",
        "root": os.path.join(BASE_DIR, "APA_v03"),
        "description": "Latest version with extended I/O, regional masking, and improved processing"
    }
}


def get_file_tree(root, rel=""):
    tree = []
    full = os.path.join(root, rel) if rel else root
    try:
        entries = sorted(os.listdir(full))
    except Exception:
        return tree
    dirs = [e for e in entries if os.path.isdir(os.path.join(full, e)) and not e.startswith(".")]
    files = [e for e in entries if os.path.isfile(os.path.join(full, e)) and e.endswith(".m")]
    for d in dirs:
        child_rel = os.path.join(rel, d) if rel else d
        children = get_file_tree(root, child_rel)
        if children:
            tree.append({"type": "dir", "name": d, "path": child_rel, "children": children})
    for f in files:
        child_rel = os.path.join(rel, f) if rel else f
        tree.append({"type": "file", "name": f, "path": child_rel})
    return tree


def build_version_tree(ver_key):
    ver = VERSIONS[ver_key]
    if ver_key == "APA_v02":
        return [{"type": "file", "name": "APA_v02.m", "path": "APA_v02.m"}]
    return get_file_tree(ver["root"])


@app.route("/")
def index():
    versions = []
    for key, ver in VERSIONS.items():
        tree = build_version_tree(key)
        file_count = count_files(tree)
        versions.append({
            "key": key,
            "label": ver["label"],
            "description": ver["description"],
            "file_count": file_count,
            "tree": tree
        })
    return render_template("index.html", versions=versions)


def count_files(tree):
    count = 0
    for node in tree:
        if node["type"] == "file":
            count += 1
        else:
            count += count_files(node.get("children", []))
    return count


@app.route("/file/<version>/<path:filepath>")
def get_file(version, filepath):
    if version not in VERSIONS:
        abort(404)
    ver = VERSIONS[version]
    if version == "APA_v02":
        if filepath != "APA_v02.m":
            abort(404)
        full_path = os.path.join(BASE_DIR, "APA_v02.m")
    else:
        full_path = os.path.join(ver["root"], filepath)

    full_path = os.path.realpath(full_path)
    root_real = os.path.realpath(BASE_DIR)
    if not full_path.startswith(root_real):
        abort(403)
    if not os.path.isfile(full_path):
        abort(404)
    try:
        with open(full_path, "r", encoding="utf-8") as f:
            content = f.read()
    except Exception:
        abort(500)

    lines = content.splitlines()
    return jsonify({
        "filename": os.path.basename(filepath),
        "path": filepath,
        "content": content,
        "line_count": len(lines)
    })


if __name__ == "__main__":
    app.run(host="0.0.0.0", port=5000, debug=False)

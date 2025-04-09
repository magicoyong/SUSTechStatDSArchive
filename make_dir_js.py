import os
import json

def remove_all_json_files(root_path, exclude=None):
    for dirpath, _, filenames in os.walk(root_path):
        for file in filenames:
            if file.endswith(".json"):
                file_path = os.path.join(dirpath, file)
                if exclude and os.path.abspath(file_path) == os.path.abspath(exclude):
                    continue
                os.remove(file_path)
                print(f"Deleted: {file_path}")

def build_tree(base_path, rel_path=""):
    full_path = os.path.join(base_path, rel_path)
    tree = {
        "name": os.path.basename(full_path) if rel_path else "Courses",
        "path": rel_path.replace("\\", "/"),
        "directories": [],
        "files": []
    }

    for item in sorted(os.listdir(full_path)):
        item_path = os.path.join(full_path, item)
        rel_item_path = os.path.join(rel_path, item).replace("\\", "/")
        if os.path.isdir(item_path):
            tree["directories"].append(build_tree(base_path, rel_item_path))
        elif os.path.isfile(item_path):
            if item.endswith(".json"):
                continue
            tree["files"].append({
                "name": item,
                "url": rel_item_path
            })
    return tree

if __name__ == "__main__":
    base_directory = "./courses"
    output_file = "directory.json"

    #print("🔍 清除旧 JSON 文件中...")
    #remove_all_json_files(base_directory)

    print("\n📁 生成目录树 JSON 中...")
    tree = build_tree(base_directory)

    with open(output_file, "w", encoding="utf-8") as f:
        json.dump(tree, f, ensure_ascii=False, indent=2)

    print(f"\n✅ 生成完成：{output_file}")

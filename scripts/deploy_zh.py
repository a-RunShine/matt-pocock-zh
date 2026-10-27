#!/usr/bin/env python3
"""检查（默认）或同步 中文版本/ 到 Qoder 的 skills 安装目录。

默认只读：报告仓库与安装目录之间的差异，有漂移时非零退出。
--apply：备份被覆盖的文件后，把有差异的文件从仓库复制到安装目录。
"""

from __future__ import annotations

import argparse
import shutil
import sys
import time
from pathlib import Path

ROOT = Path(__file__).resolve().parent.parent
ZH = ROOT / "中文版本"
BUCKETS = ["engineering", "in-progress", "misc", "productivity"]
DEFAULT_TARGET = Path.home() / ".qoder-cn" / "skills"


def skill_dirs() -> dict[str, Path]:
    mapping: dict[str, Path] = {}
    for bucket in BUCKETS:
        for d in (ZH / bucket).iterdir():
            if d.is_dir():
                mapping[d.name] = d
    return mapping


def files_under(base: Path) -> set[str]:
    return {p.relative_to(base).as_posix() for p in base.rglob("*") if p.is_file()}


def main() -> int:
    ap = argparse.ArgumentParser()
    ap.add_argument("--apply", action="store_true", help="执行同步（默认只检查）")
    ap.add_argument("--target", default=str(DEFAULT_TARGET), help="安装目录")
    args = ap.parse_args()
    target = Path(args.target)

    mapping = skill_dirs()
    changes: list[tuple[str, str, str]] = []
    missing_skills: list[str] = []
    extras: list[tuple[str, str]] = []

    for name, repo_dir in sorted(mapping.items()):
        inst_dir = target / name
        if not inst_dir.is_dir():
            missing_skills.append(name)
            continue
        repo_files = files_under(repo_dir)
        inst_files = files_under(inst_dir)
        for rel in sorted(repo_files):
            src = repo_dir / rel
            dst = inst_dir / rel
            if rel not in inst_files:
                changes.append((name, rel, "missing-in-installed"))
            elif src.read_bytes() != dst.read_bytes():
                changes.append((name, rel, "diff"))
        for rel in sorted(inst_files - repo_files):
            extras.append((name, rel))

    print(f"仓库 skill：{len(mapping)}；安装目录：{target}")
    print(f"需要同步：{len(changes)} 个文件；安装目录缺失 skill：{len(missing_skills)}；安装目录多出文件：{len(extras)}")
    for name, rel, kind in changes:
        print(f"  {kind:20} {name}/{rel}")
    for name in missing_skills:
        print(f"  missing-skill        {name}")
    for name, rel in extras:
        print(f"  extra-in-installed   {name}/{rel}")

    if not args.apply:
        return 0 if not changes and not missing_skills else 1

    stamp = time.strftime("%Y%m%d-%H%M%S")
    backup = target.parent / f"skills-backup-{stamp}"
    copied = 0
    for name, rel, kind in changes:
        src = mapping[name] / rel
        dst = target / name / rel
        if dst.exists():
            bak = backup / name / rel
            bak.parent.mkdir(parents=True, exist_ok=True)
            shutil.copy2(dst, bak)
        dst.parent.mkdir(parents=True, exist_ok=True)
        shutil.copy2(src, dst)
        copied += 1
    print(f"已同步 {copied} 个文件；备份目录：{backup}")
    print("未处理缺失 skill 与安装目录多出的文件，请人工确认。")
    return 0


if __name__ == "__main__":
    sys.exit(main())

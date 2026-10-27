// @ts-check
// 为 dependency-cruiser 实施深度模块约束。
//
// packages 根目录下的每个包都是一个深度模块：在一个小接口背后蕴含大量行为。
// 一个包的公开表面是它的入口点：位于包根目录的文件。
// 实现位于子文件夹中，并且是私有的（按约定，`lib/` 存放实现，`tests/` 存放测试，
// 不过任何子文件夹都是私有的）。一个包可以暴露多个小型入口点
// （index.ts、client.ts、server.ts 等）；优先采用这种方式，而不是一个巨大的
// 桶文件 index。
//
// 你唯一需要编辑的只有 PACKAGES_ROOT。

/** 包所在的目录。每个包是其直接子目录（扁平结构，不嵌套）。 */
const PACKAGES_ROOT = "src/packages";

// --- 派生的模式（无需编辑）-------------------------------------
const R = PACKAGES_ROOT;
/**
 * 一个包的私有内部：包子文件夹中嵌套的任何内容。
 * 包的根文件是它的入口点，不在此处匹配：
 * 它们仍然可以从外部导入。
 */
const PACKAGE_INTERNALS = `^${R}/[^/]+/[^/]+/`;

/** @type {import('dependency-cruiser').IConfiguration} */
module.exports = {
  forbidden: [
    {
      name: "entrypoint-boundary-from-app",
      comment:
        "应用/根目录代码可以导入一个包的入口点（其根文件），但不能导入其子文件夹中的任何内容。",
      severity: "error",
      from: { pathNot: `^${R}/` }, // 导入者不在任何包之内
      to: { path: PACKAGE_INTERNALS },
    },
    {
      name: "entrypoint-boundary-across-packages",
      comment:
        "一个包自己的文件可以自由地相互导入，但访问其他包时只能通过它们的入口点，绝不能访问其内部。",
      severity: "error",
      // 导入者位于某个包之内（$1），且不是测试文件
      from: { path: `^${R}/([^/]+)/`, pathNot: `^${R}/[^/]+/tests/` },
      to: {
        path: PACKAGE_INTERNALS,
        pathNot: `^${R}/$1/`, // 同一个包 → 包内自由
      },
    },
    {
      name: "tests-through-entrypoints",
      comment:
        "一个包的测试与其他所有人一样，通过入口点来行使它：它们可以导入任何包的入口点，以及它们自己的 tests/ 夹具，但绝不能导入任何包的内部，包括它们自己包的内部。",
      severity: "error",
      from: { path: `^${R}/([^/]+)/tests/` }, // 位于包 $1 中的测试文件
      to: {
        path: PACKAGE_INTERNALS,
        pathNot: `^${R}/$1/tests/`, // 自己的 tests/ 夹具 → 允许
      },
    },
    {
      name: "tests-folder-is-private",
      comment:
        "一个包的 tests/ 文件夹只能从测试中访问：其他任何东西都不能导入夹具。",
      severity: "error",
      from: { pathNot: `^${R}/[^/]+/tests/` }, // 导入者本身不是测试
      to: { path: `^${R}/[^/]+/tests/` },
    },
    {
      name: "no-circular",
      comment: "不允许依赖循环。如果要允许包外的循环，请将范围限定为 `^${R}/`。",
      severity: "error",
      from: {},
      to: { circular: true },
    },

    // --- 分层（可选，默认关闭）----------------------------------
    // 接口隐藏控制的是“如何”导入（通过入口点）。
    // 分层控制的是“哪些”包可以依赖哪些包。在此添加你自己的规则，
    // 例如：
    //
    // {
    //   name: "ui-may-not-depend-on-billing",
    //   severity: "error",
    //   from: { path: `^${R}/ui/` },
    //   to:   { path: `^${R}/billing/` },
    // },
  ],
  options: {
    doNotFollow: { path: "node_modules" },
    tsConfig: { fileName: "tsconfig.json" },
    enhancedResolveOptions: {
      extensions: [".ts", ".tsx", ".js", ".jsx", ".json"],
    },
  },
};

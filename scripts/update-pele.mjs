#!/usr/bin/env node

import { execFileSync } from "node:child_process";
import {
  mkdtempSync,
  readFileSync,
  readdirSync,
  rmSync,
  writeFileSync,
} from "node:fs";
import { tmpdir } from "node:os";
import path from "node:path";
import process from "node:process";

const BUNDLE = "package/dist/pele.global.js";

const tmp = mkdtempSync(path.join(tmpdir(), "pele-"));

try {
  const [{ version, filename }] = JSON.parse(
    execFileSync(
      "npm",
      ["pack", `pele@${process.argv[2] ?? "latest"}`, "--json"],
      { cwd: tmp }
    )
  );
  execFileSync("tar", ["-xzf", filename, BUNDLE], { cwd: tmp });

  readdirSync("assets")
    .filter((file) => /^pele-.*\.global\.js$/.test(file))
    .forEach((file) => rmSync(path.join("assets", file)));

  const asset = `assets/pele-${version}.global.js`;
  writeFileSync(asset, readFileSync(path.join(tmp, BUNDLE), "utf8").trimEnd());

  const about = JSON.parse(readFileSync("about.json", "utf8"));
  about.assets.pele_js = asset;
  writeFileSync("about.json", `${JSON.stringify(about, null, 2)}\n`);

  console.log(`Updated ${asset}`);
} finally {
  rmSync(tmp, { recursive: true });
}

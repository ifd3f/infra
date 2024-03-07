import yaml from "json-to-pretty-yaml";
import path from "path";
import fs from "fs/promises";

const HEADER = "# THIS FILE IS AUTO-GENERATED! DO NOT MODIFY DIRECTLY!";

export type Env = "dev" | "staging" | "prod";
export type GenParams = {
  env: Env;
};

export interface File {
  filename: string;
  content: (params: GenParams) => object;
}

export class FileWriter {
  constructor(
    private prefix: string,
    private genParams: GenParams,
  ) {}

  async writeFile(file: File) {
    const dest = path.join(this.prefix, file.filename);
    console.log(`Writing file ${dest}`);

    const data = yaml.stringify(file.content(this.genParams));
    const toWrite = HEADER + "\n" + data;
    await fs.mkdir(path.dirname(dest), { recursive: true });
    await fs.writeFile(dest, toWrite);
  }

  async writeFiles(files: Array<File>) {
    const promises = files.map(async (file) => await this.writeFile(file));
    for (const p of promises) {
      await p;
    }
  }
}

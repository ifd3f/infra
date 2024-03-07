import { V1DeploymentSpec } from "@kubernetes/client-node";
import { FileWriter } from "./writer";

const exampledeployment = {
  apiVersion: "v1",
  kind: "Deployment",
  metadata: {
    name: "example-deployment",
  },
  spec: {
    selector: {},
    template: {},
  } as V1DeploymentSpec,
};

const files = [
  {
    filename: "example-deployment.yaml",
    content: (_: any) => exampledeployment,
  },
];

const writers = [
  new FileWriter("manifests/prod", {
    env: "prod",
  }),
  new FileWriter("manifests/staging", {
    env: "staging",
  }),
  new FileWriter("manifests/dev", {
    env: "dev",
  }),
];

for (const writer of writers) {
  writer.writeFiles(files);
}

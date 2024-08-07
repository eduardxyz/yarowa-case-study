# Case Study for DevSecOps role at Yarowa AG

This repository is the base of the case study for all potential DevSecOps engineers at Yarowa AG.

## Steps to run

#### 1. Installing Tools
Consider using [ASDF](https://asdf-vm.com/) to install all my CLI tools declared in `.tool-versions` for better version control.

```bash
# Plugins must be installed first with
asdf plugin add <plugin_name>

# From root directory
asdf install
```

#### 2. Create the Kind Cluster



```bash
kind create cluster --config=kind.yaml
```

#### 3. Web Application

- A Vite + ReactJS web app has been created under `app/`.
- The `vite.config.js` is modified to run on port 5000 for both, development and preview modes.
- For local development, use `npm run dev`. After completing local development, build and test the application with `npm run build` and `npm run preview`.

**Disclaimer**: On MacOS, running the application might interfere with AirPlay. Disable AirPlay first if necessary.


#### 4. Dockerizing the Application

- The `Dockerfile` is located in the `/` directory and builds the web app located inside the `app/` directory.

- After building the Docker image, push it to Docker Hub:

```bash
docker build -t <dockerhub_username>/yarowa-web-app:0.1.0 .
docker push <dockerhub_username>/yarowa-web-app:0.1.0
```


#### 5. Helm Chart

- The `helmchart/` directory contains the template for the Kubernetes deployment.
- No additional configuration is required.


#### 6. Host Configuration
- Add the following entries to your `/etc/hosts` file:

```txt
127.0.0.1 casestudy.local.yarowa.io
127.0.0.1 prometheus.local.yarowa.io
127.0.0.1 grafana.local.yarowa.io
```


#### 7. Helmfile Configuration

- The `helmfile.d/` directory contains the configuration files for:
    - Local Helm chart deployment
    - Ingress controller setup
    - Prometheus and Grafana setup

**Disclaimer**: Due to lack of compute resources, metrics exportation is not configured.

#### 8. Running the setup

1. Apply helmfile configuration:
```bash
cd helmfile.d/
helmfile apply
```

2. Access the Applications
- Web Application: http://casestudy.local.yarowa.io
- Prometheus: http://prometheus.local.yarowa.io
- Grafana: http://grafana.local.yarowa.io



## Instructions

1. Fork this repository and mark it as private.
1. Build an application using the programming language of your choice in the `app/` folder which runs a webservice on Port 5000 and responds with "Hello Yarowa AG!" to any requests (e.g. curl http://localhost:5000/).
1. Build a Dockerfile which packages the app into a container and runs the previously written app on startup.
1. Build a Helmchart in `helmchart/` that runs the docker container in a deployment with a service and ingress infront of it.
1. Orchestrate the helmchart deployment in `helmfile.d/` and add all helm charts needed to serve the application starting from a brand new kind/k3s/minikube cluster.
1. Commit all code to your repo.
1. Send the zipped repo to your contact at Yarowa and wait for feedback.

## Guidelines / Rules

- Please take note on how long you took to get this case study done (ideally you shouldn't spend more than 4 hours).
- The ingress should listen to the Domain/Host: casestudy.local.yarowa.io (DNS is statically pointing to 127.0.0.1 so you will need to setup a minikube/k3s/kind environment that listens on localhost).
- The ingress should listen on HTTP only and forward the requests to the setup service.
- You might need to publish your Dockerimage on dockerhub.com or leave instructions on how the k8s cluster can pull the image.
- Your custom helmchart for the "Hello Yarowa!" applicatioan can be referenced using relative paths (e.g. `chart: ../helmchart/mychart`).
- Please transparently declare the use of ChatGPT or other AI helpers as comments in the files if you use them.
- If you add other helmcharts with ingresses you can use *.local.yarowa.io (e.g. grafana.local.yarowa.io)

## Scoring

The verifier of this challenge will clone your repository and run "helmfile apply ." and then trying to access casestudy.local.yarowa.io in a browser. Make sure to leave instructions if the kind/minikube/k3s setup needs special configs to expose the ports 80 / 443.

- `app/` contains working code: 10 Points
- `helmchart/` contains working helmchart: 10 Points
- `helmfile.d/` contains full orchestration of setup: 30 Points
- verifier can successfully open casestudy.local.yarowa.io and received "Hello Yarowa!" as response: 50 Points
- Up to 50 Bonus points for: elegant code (10pts), full instrumentation (20pts), test cases (10pts), surprising solutions (10pts)
- Maximum Score: 150 Points
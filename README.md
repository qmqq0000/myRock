
Docker Containers As Jenkins Build Slaves

1. Install Docker
        https://docs.docker.com/install/
        
2. Enable docker remote API
        https://scriptcrunch.com/enable-docker-remote-api/
        
        Linux (Centos):
        docker config: /lib/systemd/system/docker.service
          ExecStart=/usr/bin/dockerd -H tcp://0.0.0.0:4243 -H unix:///var/run/docker.sock
        Windows 10 Enterprise:
        C:\ProgramData\Docker\config\daemon.json
          "hosts": ["tcp://0.0.0.0:4243"]
        
3. Configure Jenkins Server

   3.1 Head over to Jenkins Dashboard –> Manage jenkins –> Manage Plugins.

   3.2 Under available tab, search for “Docker Plugin” and install it.

   3.3 Once installed, head over to jenkins Dashboard –> Manage jenkins –>Configure system.

   3.4 Under “Configure System”, if you scroll down, there will be a section named “cloud” at the last. There you can fill out the docker host parameters for spinning up the slaves.

   3.5 Under docker, you need to fill out the details as shown in the image below.

   Note: Replace “Docker URL” with your docker host IP. You can use the “Test connection” to test if jenkins is able to connect to the docker host.

   3.6 Now, from “Add Docker Template” dropdown, click “docker template” and fill in the details based on the explanation and the image given below.

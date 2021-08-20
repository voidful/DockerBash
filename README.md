# DockerBash
Create docker container with openssh server.

# User guide

1. Enter username

    ```Create UserName  : test```

2. Enter password (default is "password")

    ```Setting Password  [ default : password ] : test```

3. Enter the SSH port you want to use

    ```Setting SSH's Port  : 420```

4. Enter the published ports you want to use (whitespace as a split)

    ```Setting published ports (8080:8080 5000:5000...)  : 8080:8080 5000:5000```

5. Enter the image you want to use

    ```Image  : ubuntu:18.04```

6. Enter the package you want to install (whitespace as a split)

    ```Apt package (nano vim...) : nano micro tmux```

7. Confirm your setting

    ```You Setting:
    User: test
    Password: test
    SSH Port: 420
    Published ports:
    25565:123
    25555:321
    Are you sure ? [Y/n] y
    ```

8. Enjoy your container

    ```
    test
    * Starting OpenBSD Secure Shell server sshd [ OK ]
    Container create finish
    Login as root, SSH port 420
    ```

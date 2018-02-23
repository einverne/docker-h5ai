# h5ai

[h5ai](http://larsjung.de/h5ai/) is a modern web server index.

借助 Docker 镜像可以快速的分享文件列表。

![screenshot](https://cloud.githubusercontent.com/assets/776829/3098666/440f3ca6-e5ef-11e3-8979-36d2ac1a36a0.png)

例子 [demo directory](http://larsjung.de/h5ai/sample).

## 直接使用 Usage

docker 镜像可以再 DockerHub [找到](https://hub.docker.com/r/einverne/docker-h5ai/),

直接运行:

```bash
$ sudo docker run -it --rm -p 81:80 -v `pwd`:/var/www einverne/docker-h5ai
```

浏览器访问：

```
http://localhost:81
```

下面是 docker 的参数解释：

* `-it` 运行交互式，会开启STDIN，容器会在命令 `CTRL+C` 结束时销毁，长期运行可不加此参数
* `--rm` 当退出容器时自动移除容器，长期运行可不加此参数
* `-v {AnyDirectory}:/var/www` 通过`-v` 参数挂载卷，将宿主机想要共享的目录填入 AnyDirectory
* `-p {OutsidePort}:80` 将容器80端口映射到宿主机端口
* `clue/h5ai` docker 镜像的名字

## 本地 build

克隆本项目，然后运行

    git clone https://github.com/einverne/docker-h5ai.git
    cd docker-h5ai
    sudo docker build -t "docker-h5ai" .

默认的密码为 user -> password， 如果需要修改，更改 `index.php.patch` 文件中第20行，修改为自己想要的用户名和密码。

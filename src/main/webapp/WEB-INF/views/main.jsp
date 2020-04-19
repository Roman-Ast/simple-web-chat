<%@ page contentType="text/html;charset=UTF-8" language="java" isELIgnored="false"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jstl/core"%>
<html>
    <head>
        <title>Chat</title>
    </head>
    <style>
        .chatbox{
            display:none;
        }
        .messages{
            background-color:#369;
            width:500px;
            padding:20px;
        }
        .messages .msg{
            background-color: #fff;
            border-radius:10px;
            margin-bottom: 10px;
            overflow:hidden;
        }
        .messages .msg .from{
             background-color: #396;
             line-height:30px;
             text-align:center;
             color:white;
        }
        .messages .msg .text{
              padding:10px;
        }
        textarea.msg{
            width:540px;
            padding:10px;
            resize:none;
            border:none;
            box-shadow:2px 2px 2px 5 inset;
        }
    </style>
    <script>
        let chatUnit = {
            init() {
                this.startBox = document.querySelector(".start");
                this.chatBox = document.querySelector(".chatbox");

                this.nameInput = this.startBox.querySelector("input");
                this.msgTextArea = this.chatBox.querySelector("textarea");
                this.startBtn = this.startBox.querySelector("button");
                this.chatMessageContainer = this.chatBox.querySelector(".messages");

                this.bindEvents();
            },
            bindEvents() {
                this.startBtn.addEventListener("click", e => this.openSocket());
                this.msgTextArea.addEventListener("keyup", e => {
                    if (e.ctrlKey && e.keyCode === 13) {
                        e.preventDefault();
                        this.send();
                    }
                });
            },
            send() {
                this.sendMessage({
                    name: this.name,
                    text: this.msgTextArea.value
                });
            },
            onOpenSock() {

            },
            onMessage(inputMsg) {
                let msgBlock = document.createElement("div");
                msgBlock.className = "msg";

                let fromBlock = document.createElement("div");
                fromBlock.className = "from";
                fromBlock.innerText = inputMsg.name;

                let textBlock = document.createElement("div");
                textBlock.className = "text";
                textBlock.innerText = inputMsg.text;

                msgBlock.appendChild(fromBlock);
                msgBlock.appendChild(textBlock);

                this.chatMessageContainer.appendChild(msgBlock);
            },
            onClose() {

            },
            sendMessage(msg) {
                this.onMessage({name: "I`m", text: msg.text});
                this.msgTextArea.value = "";
                this.ws.send(JSON.stringify(msg));
            },
            openSocket() {
                this.ws = new WebSocket("ws://localhost:8080/sock/chat");
                this.ws.onopen = () => this.onOpenSock;
                this.ws.onmessage = (e) => this.onMessage(JSON.parse(e.data));
                this.ws.onclose = () => this.onClose();

                this.name = this.nameInput.value;
                this.startBox.style.display = "none";
                this.chatBox.style.display = "block";
            }
        };

        window.addEventListener("load", e => chatUnit.init());
    </script>
    <body>
        <h1>Онлайн чат</h1>
        <div class="start">
            <input type="text" class="username" placeholder="ваше имя">
            <button id="start">start</button>
        </div>
        <div class="chatbox">
            <div class="messages">

            </div>
            <textarea rows="3" class="msg"></textarea>
        </div>
    </body>
</html>
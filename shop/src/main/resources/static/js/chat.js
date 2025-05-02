$(document).ready(function () {
    const fabOpenBtn = $('#fab-open');
    const fabCloseBtn = $('#fab-close');
    const chatModal = $('#chat-modal');
    const chatMessages = $('#chat-messages');
    const chatInput = $('#chat-input');
    const sendButton = $('#send-button');

    let stompClient = null;
    let subscription = null;
    let username = typeof chatUsername !== 'undefined' ? chatUsername : 'User_Guest';
    let currentChatMode = 'livechat';
    let chatbotHistory = [];

    function connectChat() {

        if (stompClient && stompClient.connected) {
            console.log('Already connected.');
            return;
        }

        const socket = new SockJS(typeof websocketUrl !== 'undefined' ? websocketUrl : 'http://127.0.0.1:8088/ws');
        stompClient = Stomp.over(socket);

        stompClient.connect({}, function (frame) {
            console.log('Connected: ' + frame);
            updateChatHeader('실시간 상담');
            chatMessages.html('<div style="color: green; text-align: center;">실시간 상담에 연결되었습니다.</div>');

            subscription = stompClient.subscribe('/livechat/public', function (messageOutput) {
                showMessageOutput(JSON.parse(messageOutput.body));
            });

            stompClient.subscribe('/send/to/' + username, function (messageOutput) {
                const message = JSON.parse(messageOutput.body);
                message.sendid = "[Admin] " + message.sendid;
                showMessageOutput(message);
            });

            // 서버에 사용자 입장 메시지 전송 -> 아직 구현안함
            // stompClient.send("/app/livechat.addUser", {}, JSON.stringify({sender: username, type: 'JOIN'}));

        }, function (error) {
            console.error('STOMP connection error: ' + error);
            chatMessages.html('<div style="color: red; text-align: center;">연결에 실패했습니다. 새로고침 후 다시 시도해주세요.</div>');
        });
    }

    function disconnectChat() {
        if (stompClient !== null && stompClient.connected) {
            // 서버에 사용자 퇴장 메시지 전송 -> 아직 구현안함 
            // stompClient.send("/app/livechat.sendMessage", {}, JSON.stringify({sender: username, type: 'LEAVE', content:''}));

            if (subscription) {
                subscription.unsubscribe();
                subscription = null;
            }
            stompClient.disconnect(function () {
                console.log("Disconnected");
                updateChatHeader('PetGPT 실시간 상담');
                chatMessages.html('<div style="color: #888; text-align: center;">실시간 상담 연결이 종료되었습니다.</div>');
            });
            stompClient = null;
        }
    }

    function sendLiveChatMessage() {
        const messageContent = chatInput.val().trim();
        if (messageContent && stompClient && stompClient.connected) {
            const chatMessage = {
                sendid: username,
                content1: messageContent
            };

            showMessageOutput({ sendid: username, content1: messageContent });
            stompClient.send("/app/livechat.sendMessage", {}, JSON.stringify(chatMessage));
            chatInput.val('');
        } else if (!stompClient || !stompClient.connected) {
            alert("서버에 연결되지 않았습니다.");
        }
    }

    function sendChatbotMessage() {
        const messageContent = chatInput.val().trim();
        if (messageContent) {
            showMessageOutput({ sendid: username, content1: messageContent });
            chatInput.val('');
            showMessageOutput({ sendid: 'PetGPT', content1: '답변 생성 중...', isLoading: true });

            $.ajax({
                url: typeof chatbotApiUrl !== 'undefined' ? chatbotApiUrl : '/api/chatbot/ask',
                type: 'POST',
                contentType: 'application/json',
                data: JSON.stringify({ message: messageContent }),
                success: function (response) {
                    chatMessages.find('.loading-message').remove();
                    showMessageOutput({ sendid: 'PetGPT', content1: response.reply });
                },
                error: function (xhr, status, error) {
                    console.error("Chatbot API error:", status, error);
                    chatMessages.find('.loading-message').remove();
                    showMessageOutput({ sendid: 'PetGPT', content1: '죄송합니다. 답변을 가져오는 중 오류가 발생했습니다.' });
                }
            });
        }
    }

    function showMessageOutput(messageOutput) {
        const messageElement = $('<div></div>');

        if (messageOutput.isLoading) {
            messageElement.addClass('loading-message');
            messageElement.text(messageOutput.content1);
        } else {
            messageElement.addClass('message-bubble');

            if (messageOutput.sendid === username) {
                messageElement.addClass('user-message');
                messageElement.text(messageOutput.content1);
            } else {
                messageElement.addClass('bot-message');
                const senderName = messageOutput.sendid || 'PetGPT';
                const nameElement = $('<strong></strong>').text(senderName + ':');
                const contentElement = $('<span></span>').text(messageOutput.content1);
                messageElement.append(nameElement).append(contentElement);
            }
        }

        if (chatMessages.find('div.initial-message').length > 0) {
            if (!messageOutput.isLoading) {
                chatMessages.find('div.initial-message').remove();
            }
        } else if (chatMessages.find('div:contains("연결되었습니다"), div:contains("종료되었습니다"), div:contains("챗봇 모드입니다")').length > 0) {
            if (!messageOutput.isLoading) {
                chatMessages.empty();
            }
        }

        chatMessages.append(messageElement);
        setTimeout(() => {
            chatMessages.scrollTop(chatMessages[0].scrollHeight);
        }, 50);
    }

    function updateChatHeader(title) {
        $('#chat-modal .modal-title').text(title);
    }

    fabOpenBtn.on('click', function () {
        fabOpenBtn.addClass('fab-hidden').removeClass('fab-visible');
        setTimeout(function () {
            fabCloseBtn.show().addClass('fab-visible').removeClass('fab-hidden');
        }, 200);

        chatModal.show().addClass('active');
        switchToChatbotMode();
    });

    fabCloseBtn.on('click', function () {
        chatModal.removeClass('active');
        fabCloseBtn.addClass('fab-hidden').removeClass('fab-visible');
        if (currentChatMode === 'livechat') {
            disconnectChat();
        }

        setTimeout(function () {
            chatModal.hide();
            fabCloseBtn.hide();
            fabOpenBtn.addClass('fab-visible').removeClass('fab-hidden');
        }, 300);
    });

    sendButton.on('click', function () {
        if (currentChatMode === 'livechat') {
            sendLiveChatMessage();
        } else {
            sendChatbotMessage();
        }
    });

    chatInput.on('keypress', function (e) {
        if (e.key === 'Enter' || e.keyCode === 13) {
            if (currentChatMode === 'livechat') {
                sendLiveChatMessage();
            } else {
                sendChatbotMessage();
            }
        }
    });

    $('#modal-chatbot-btn').on('click', function () {
        switchToChatbotMode();
    });

    $('#modal-livechat-btn').on('click', function () {
        switchToLiveChatMode();
    });

    function switchToChatbotMode() {
        if (currentChatMode === 'chatbot') return;

        console.log("Switching to Chatbot mode");
        currentChatMode = 'chatbot';
        updateChatHeader('PetGPT 챗봇 상담');

        if (stompClient && stompClient.connected) {
            disconnectChat();
        }

        chatMessages.html('<div class="initial-message">챗봇 모드입니다. 무엇이든 물어보세요!</div>');
        chatInput.focus();
    }

    function switchToLiveChatMode() {
        if (currentChatMode === 'livechat' && stompClient && stompClient.connected) return;

        console.log("Switching to Live Chat mode");
        currentChatMode = 'livechat';
        updateChatHeader('PetGPT 실시간 상담');
        chatMessages.html('<div class="initial-message">실시간 상담 연결 중...</div>');
        connectChat();
        chatInput.focus();
    }

    fabOpenBtn.addClass('fab-visible').removeClass('fab-hidden');
});
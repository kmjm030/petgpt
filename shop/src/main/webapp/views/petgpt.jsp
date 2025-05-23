<%@ page contentType="text/html;charset=UTF-8" language="java" %>
  <%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>

    <!DOCTYPE html>
    <html lang="ko">

    <head>
      <meta charset="UTF-8">
      <meta name="viewport" content="width=device-width, initial-scale=1.0">
      <title>PetGPT AI Chat</title>
      <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.5.1/css/all.min.css"
        integrity="sha512-DTOQO9RWCH3ppGqcWaEA1BIZOC6xxalwEsw9c2QQeAIftl+Vegovlnee1c9QX4TctnWMn13TZye+giMm8e2LwA=="
        crossorigin="anonymous" referrerpolicy="no-referrer" />
      <link rel="preconnect" href="https://fonts.googleapis.com">
      <link rel="preconnect" href="https://fonts.gstatic.com" crossorigin>
      <link href="https://fonts.googleapis.com/css2?family=Roboto:wght@300;400;500;700&display=swap" rel="stylesheet">
      <link rel="stylesheet" href="<c:url value='/css/petgpt.css'/>">
      <script src="https://cdn.jsdelivr.net/npm/marked/marked.min.js"></script>
    </head>

    <body>
      <aside class="sidebar" id="sidebar">
        <div class="sidebar-header">
          <button class="new-chat-btn" id="newChatBtn">
            <i class="fa-regular fa-pen-to-square"></i>
            <span class="btn-text">새 채팅</span>
          </button>
          <button class="icon-btn" id="collapseSidebarBtn" title="사이드바 숨기기">
            <i class="fa-solid fa-chevron-left"></i>
          </button>
        </div>
        <nav class="sidebar-nav">
          <ul>
            <li><a href="#" class="active"><i class="fa-solid fa-brain"></i> <span class="link-text">PetGPT
                  AI</span></a></li>
          </ul>
        </nav>
        <div class="sidebar-history">
          <h4><span class="link-text">오늘</span></h4>
          <ul id="historyToday">
          </ul>
        </div>
        <div class="sidebar-footer">
        </div>
      </aside>

      <main class="chat-area" id="chatArea">
        <button class="sidebar-toggle-btn" id="openSidebarBtn" title="사이드바 열기">
          <i class="fa-solid fa-bars"></i>
        </button>

        <header class="chat-header">
          <div class="chat-header-actions">
          </div>
        </header>

        <div class="chat-content" id="chatContent">
          <div class="initial-prompt" id="initialPrompt">
            <h1>무엇이든 물어보세요!</h1>
          </div>
        </div>

        <div class="message-input-area">
          <div class="quick-reply-suggestions" id="quickReplySuggestions">
          </div>
        </div>

        <footer class="message-input-container">
          <div class="input-wrapper">
            <button class="icon-btn" title="파일 첨부" id="attachFileBtn" style="display: none;">
              <i class="fa-solid fa-paperclip"></i>
            </button>
            <textarea id="messageInput" placeholder="오늘 어떤 도움을 드릴까요?" rows="1"></textarea>
            <button class="icon-btn gemini-btn" id="suggestReplyBtn" title="✨ 빠른 답변 제안받기">
              <span class="gemini-icon">✨</span>
            </button>
            <button class="icon-btn" title="음성으로 입력" id="micBtn" style="display: none;">
              <i class="fa-solid fa-microphone"></i>
            </button>
            <button class="icon-btn send-btn" id="sendButton" title="보내기">
              <i class="fa-solid fa-paper-plane"></i>
            </button>
          </div>
        </footer>
      </main>

      <div id="summaryModal" class="modal">
        <div class="modal-content">
          <div class="modal-header">
            <h2>✨ 대화 요약</h2>
            <button class="close-btn" id="closeSummaryModal">×</button>
          </div>
          <div class="modal-body" id="summaryModalBody">
            <div class="loading-indicator">
              <i class="fas fa-spinner fa-spin"></i> 요약하는 중...
            </div>
          </div>
        </div>
      </div>

      <script>
        const sidebar = document.getElementById('sidebar');
        const collapseSidebarBtn = document.getElementById('collapseSidebarBtn');
        const openSidebarBtn = document.getElementById('openSidebarBtn');
        const messageInput = document.getElementById('messageInput');
        const sendButton = document.getElementById('sendButton');
        const chatContent = document.getElementById('chatContent');
        const initialPrompt = document.getElementById('initialPrompt');
        const suggestReplyBtn = document.getElementById('suggestReplyBtn');
        const quickReplySuggestionsContainer = document.getElementById('quickReplySuggestions');
        const newChatBtn = document.getElementById('newChatBtn');
        let chatHistory = [];
        let currentChatId = null;
        let chatSessions = JSON.parse(localStorage.getItem('petgpt_chat_sessions') || '{}');

        function saveChatSession() {
          if (chatHistory.length > 0 && currentChatId) {
            const firstUserMessage = chatHistory.find(msg => msg.role === 'user');
            if (firstUserMessage) {
              chatSessions[currentChatId] = {
                id: currentChatId,
                title: firstUserMessage.parts[0].text.substring(0, 30) + (firstUserMessage.parts[0].text.length > 30 ? '...' : ''),
                history: [...chatHistory],
                timestamp: new Date().toISOString()
              };
              localStorage.setItem('petgpt_chat_sessions', JSON.stringify(chatSessions));
            }
          }
        }

        function loadChatSession(chatId) {
          const session = chatSessions[chatId];
          if (session) {
            saveChatSession();

            currentChatId = chatId;
            chatHistory = [...session.history];

            chatContent.innerHTML = '';
            if (initialPrompt) {
              initialPrompt.style.display = 'none';
            }

            session.history.forEach(msg => {
              displayMessage(msg.role, msg.parts[0].text, false, msg.sourceDocuments || []);
            });

            console.log(`채팅 세션 로드됨: ${chatId}`);
          }
        }

        function generateChatId() {
          return 'chat_' + Date.now() + '_' + Math.random().toString(36).substr(2, 9);
        }

        function deleteChatSession(chatId) {
          if (chatSessions[chatId]) {
            delete chatSessions[chatId];
            localStorage.setItem('petgpt_chat_sessions', JSON.stringify(chatSessions));

            if (currentChatId === chatId) {
              chatHistory = [];
              currentChatId = null;
              chatContent.innerHTML = '';
              if (initialPrompt) {
                if (!chatContent.contains(initialPrompt)) {
                  chatContent.appendChild(initialPrompt);
                }
                initialPrompt.style.display = 'block';
              }
            }

            updateSidebarHistoryFromStorage();
            console.log(`채팅 세션 삭제됨: ${chatId}`);
          }
        }

        function updateSidebarHistoryFromStorage() {
          const historyTodayList = document.getElementById('historyToday');
          historyTodayList.innerHTML = '';

          const sessions = Object.values(chatSessions)
            .sort((a, b) => new Date(b.timestamp) - new Date(a.timestamp))
            .slice(0, 5);

          sessions.forEach(session => {
            const listItem = document.createElement('li');

            const chatItem = document.createElement('div');
            chatItem.className = 'chat-item';

            const chatTitle = document.createElement('span');
            chatTitle.className = 'chat-title';
            chatTitle.textContent = session.title;
            chatTitle.addEventListener('click', (e) => {
              e.preventDefault();
              e.stopPropagation();
              loadChatSession(session.id);
            });

            const deleteBtn = document.createElement('button');
            deleteBtn.className = 'delete-btn';
            deleteBtn.innerHTML = '<i class="fa-solid fa-trash"></i>';
            deleteBtn.title = '채팅 삭제';
            deleteBtn.addEventListener('click', (e) => {
              e.preventDefault();
              e.stopPropagation();
              if (confirm('이 채팅을 삭제하시겠습니까?')) {
                deleteChatSession(session.id);
              }
            });

            chatItem.appendChild(chatTitle);
            chatItem.appendChild(deleteBtn);
            listItem.appendChild(chatItem);
            historyTodayList.appendChild(listItem);
          });
        }

        function toggleSidebar() {
          sidebar.classList.toggle('collapsed');

          const isCollapsed = sidebar.classList.contains('collapsed');
          openSidebarBtn.style.display = isCollapsed ? 'inline-flex' : 'none';

          if (isCollapsed) {
            collapseSidebarBtn.innerHTML = '<i class="fa-solid fa-chevron-right"></i>';
            collapseSidebarBtn.title = "사이드바 보이기";
          } else {
            collapseSidebarBtn.innerHTML = '<i class="fa-solid fa-chevron-left"></i>';
            collapseSidebarBtn.title = "사이드바 숨기기";
          }
        }
        collapseSidebarBtn.addEventListener('click', toggleSidebar);
        openSidebarBtn.addEventListener('click', toggleSidebar);

        function checkScreenSize() {
          const isSmallScreen = window.innerWidth <= 768;
          if (isSmallScreen && !sidebar.classList.contains('collapsed')) {
            // toggleSidebar(); 
          }
          openSidebarBtn.style.display = (isSmallScreen && sidebar.classList.contains('collapsed')) ? 'inline-flex' : 'none';
        }
        window.addEventListener('resize', checkScreenSize);

        messageInput.addEventListener('input', function () {
          this.style.height = 'auto';
          let newHeight = this.scrollHeight;
          const maxHeight = 200;
          if (newHeight > maxHeight) {
            newHeight = maxHeight;
            this.style.overflowY = 'auto';
          } else {
            this.style.overflowY = 'hidden';
          }
          this.style.height = newHeight + 'px';
          sendButton.classList.toggle('enabled', this.value.trim() !== '');
        });

        function cleanResponseText(text) {
          if (typeof text !== 'string') return "";
          return text.trim();
        }

        function displayMessage(role, text, isLoading = false, sourceDocuments = []) {
          console.log("[displayMessage] Role:", role);
          console.log("[displayMessage] Text (Original):", text ? text.substring(0, 100) + "..." : "N/A"); // 원본 텍스트 일부 로깅
          console.log("[displayMessage] IsLoading:", isLoading);
          console.log("[displayMessage] Received sourceDocuments:", sourceDocuments);

          if (initialPrompt) {
            initialPrompt.style.display = 'none';
          }

          const messageBubble = document.createElement('div');
          messageBubble.classList.add('message-bubble', role);

          const avatar = document.createElement('div');
          avatar.classList.add('avatar');
          avatar.textContent = role === 'user' ? '나' : 'AI';

          const messageTextDiv = document.createElement('div');
          messageTextDiv.classList.add('message-text');

          if (isLoading) {
            messageTextDiv.innerHTML = '<div class="loading-dots"><span></span><span></span><span></span></div>';
          } else {
            let mainContentHtml = ""; // AI 응답 또는 사용자 메시지 HTML을 담을 변수

            if (role === 'user') {
              // 사용자 메시지는 마크다운 처리 없이, 개행문자만 <br>로 변경
              mainContentHtml = cleanResponseText(text).replace(/\n/g, '<br>');
            } else if (role === 'model') {
              // AI 모델 메시지는 마크다운으로 간주하고 HTML로 변환
              const markdownText = text || ""; // text가 null일 경우 빈 문자열로
              try {
                if (typeof marked === 'undefined') { // Marked.js 라이브러리 로드 확인
                  console.error("Marked.js library is not loaded. Falling back to plain text.");
                  mainContentHtml = cleanResponseText(markdownText).replace(/\n/g, '<br>');
                } else {
                  mainContentHtml = marked.parse(markdownText); // 마크다운을 HTML로 변환
                  console.log("[displayMessage] Parsed Markdown HTML:", mainContentHtml.substring(0, 100) + "...");
                }
              } catch (e) {
                console.error("Markdown parsing error:", e);
                mainContentHtml = cleanResponseText(markdownText).replace(/\n/g, '<br>'); // 파싱 실패 시 단순 텍스트 처리
              }
            } else {
              // 다른 역할의 메시지 (예: 시스템 메시지) - 단순 텍스트 처리
              mainContentHtml = cleanResponseText(text).replace(/\n/g, '<br>');
            }

            let finalHtml = mainContentHtml; // 최종적으로 messageTextDiv에 들어갈 HTML

            // AI 모델 응답일 경우에만 출처 정보 추가
            if (role === 'model' && sourceDocuments && sourceDocuments.length > 0) {
              console.log("[displayMessage] Processing source documents, Count:", sourceDocuments.length);
              let sourcesHtml = '<div class="sources-info"><strong>출처:</strong><ul>';

              sourceDocuments.forEach((doc, index) => {
                // --- 루프 내부 (이전 디버깅 로그는 간결성을 위해 일부만 남김) ---
                // console.log("[displayMessage] Loop[" + index + "] - doc object:", JSON.parse(JSON.stringify(doc)));

                const metadata = doc.metadata || {};
                const pageContent = doc.page_content || "";

                const sourceName = metadata.source ? metadata.source : '정보 출처';
                let displayText = metadata.title || metadata.item_name || sourceName || '제목 없음';
                let contentPreview = pageContent ? " (" + pageContent.substring(0, 30) + "...)" : '';

                let currentLiHtml = "";
                if (metadata.source && typeof metadata.source === 'string' && metadata.source.startsWith('http')) {
                  currentLiHtml = "<li><a href=\"" + metadata.source + "\" target=\"_blank\" rel=\"noopener noreferrer\">" + displayText + "</a>" + contentPreview + "</li>";
                } else {
                  if (displayText !== '제목 없음' || contentPreview !== "") { // 'N/A' 대신 '제목 없음'과 비교
                    currentLiHtml = "<li>" + displayText + contentPreview + "</li>";
                  } else {
                    currentLiHtml = "<li>출처 정보 없음</li>";
                  }
                }
                // console.log("[displayMessage] Loop[" + index + "] - currentLiHtml:", currentLiHtml); // 필요시 주석 해제
                sourcesHtml += currentLiHtml;
              });

              sourcesHtml += '</ul></div>';
              console.log("[displayMessage] Generated sourcesHtml:", sourcesHtml);
              finalHtml += sourcesHtml; // AI 응답 HTML(마크다운 변환됨) 뒤에 출처 HTML 추가
            }
            messageTextDiv.innerHTML = finalHtml; // 최종 HTML을 div에 삽입
          }

          messageBubble.appendChild(avatar);
          messageBubble.appendChild(messageTextDiv);
          chatContent.appendChild(messageBubble);
          chatContent.scrollTop = chatContent.scrollHeight;
          return messageBubble;
        }
        async function handleSendMessage() {
          const messageText = messageInput.value.trim();
          if (!messageText) return;

          if (!currentChatId) {
            currentChatId = generateChatId();
          } displayMessage('user', messageText);
          chatHistory.push({ role: 'user', parts: [{ text: messageText }] });
          console.log("[메시지 전송] 사용자 메시지 추가 후 chatHistory.length:", chatHistory.length);

          if (chatHistory.length === 1) {
            saveChatSession();
            updateSidebarHistoryFromStorage();
          }

          messageInput.value = '';
          messageInput.style.height = 'auto';
          messageInput.dispatchEvent(new Event('input'));
          sendButton.classList.remove('enabled');
          sendButton.disabled = true;
          quickReplySuggestionsContainer.innerHTML = '';

          const loadingBubble = displayMessage('model', '', true);

          try {
            const historyForApi = chatHistory.slice(0, -1).map(msg => ({
              role: msg.role,
              parts: msg.parts
            }));

            const response = await fetch('<c:url value="/api/chat-with-rag"/>', {
              method: 'POST',
              headers: {
                'Content-Type': 'application/json',
              },
              body: JSON.stringify({
                query: messageText,
                chat_history: historyForApi
              })
            });

            loadingBubble.remove();

            if (!response.ok) {
              let errorMsg = `API 오류: ${response.status} ${response.statusText}`;
              const responseText = await response.text();
              console.error('Backend API Error (Text):', responseText);
              try {
                const errorData = JSON.parse(responseText);
                errorMsg += ` - ${errorData.error || (errorData.message || JSON.stringify(errorData))}`;
              } catch (e) {
                errorMsg += ` - ${responseText || '내용 없음'}`;
              }
              console.error('Backend API Error (Formatted):', errorMsg);
              displayMessage('model', errorMsg);
              return;
            }

            const responseBodyText = await response.text();
            console.log("Raw response body text from Spring backend (Chat):", responseBodyText);

            let result;

            try {
              result = JSON.parse(responseBodyText);
              console.log("Parsed JSON result in JSP (Chat):", result);
            } catch (e) {
              console.error("Failed to parse JSON response from backend (Chat):", e);
              console.error("Response text was (Chat):", responseBodyText);
              displayMessage('model', "백엔드 응답을 처리하는 중 오류가 발생했습니다. (JSON 파싱 실패)");
              return;
            }

            const sourceDocs = result.source_documents || [];

            let rawAiTextFromResult = result.result;
            let processedAiText = "";

            if (typeof rawAiTextFromResult === 'string') {
              // Remove zero-width spaces and similar, then trim
              processedAiText = rawAiTextFromResult.replace(/[\\u200B-\\u200D\\uFEFF]/g, '').trim();
            }
            // If rawAiTextFromResult was not a string (e.g. null, undefined), processedAiText remains ""
            // and aiResponseText will become the fallback.

            const aiResponseText = processedAiText || "응답을 받지 못했습니다.";

            console.log("Original result.result from backend (Chat):", rawAiTextFromResult);
            console.log("Final aiResponseText for display/history (Chat):", aiResponseText);
            console.log("Source documents received in JSP (Chat):", sourceDocs);

            displayMessage('model', aiResponseText, false, sourceDocs);
            chatHistory.push({ role: 'model', parts: [{ text: aiResponseText }], sourceDocuments: sourceDocs });

            saveChatSession();

          } catch (error) {
            console.error('메시지 전송 중 네트워크 오류 또는 기타 오류:', error);
            if (loadingBubble) loadingBubble.remove();
            const networkErrorMsg = `오류가 발생했습니다: ${error.message}. 네트워크 연결을 확인해주세요.`;
            displayMessage('model', networkErrorMsg);
          } finally {
            sendButton.disabled = false;
            if (messageInput.value.trim() !== '') sendButton.classList.add('enabled');
          }
        }

        sendButton.addEventListener('click', handleSendMessage);
        messageInput.addEventListener('keydown', function (event) {
          if (event.key === 'Enter' && !event.shiftKey) {
            event.preventDefault();
            handleSendMessage();
          }
        });
        suggestReplyBtn.addEventListener('click', async () => {
          const lastAiMessage = chatHistory.filter(msg => msg.role == 'model').pop();
          if (!lastAiMessage) {
            quickReplySuggestionsContainer.innerHTML = `<button class="loading" disabled>AI 응답이 없습니다.</button>`;
            return;
          }
          const contextMessage = lastAiMessage.parts[0].text;

          quickReplySuggestionsContainer.innerHTML = `<button class="loading" disabled><i class="fas fa-spinner fa-spin"></i> 제안 로딩 중...</button>`;
          suggestReplyBtn.classList.add('loading');
          suggestReplyBtn.disabled = true;

          try {
            const response = await fetch('<c:url value="/api/suggest-replies"/>', {
              method: 'POST',
              headers: { 'Content-Type': 'application/json' },
              body: JSON.stringify({ context_message: contextMessage })
            });

            if (!response.ok) {
              let errorMsg = `빠른 답변 제안 오류 (${response.status}): ${response.statusText}`;
              const responseText = await response.text();
              console.error('Suggest Replies API Error (Text):', responseText);
              try {
                const errorData = JSON.parse(responseText);
                errorMsg += ` - ${errorData.error || JSON.stringify(errorData)}`;
              } catch (e) {
                errorMsg += ` - ${responseText || '내용 없음'}`;
              }
              throw new Error(errorMsg);
            }

            const responseBodyText = await response.text();
            console.log("Raw response body text from Spring backend (Suggest):", responseBodyText);

            let result;
            try {
              result = JSON.parse(responseBodyText);
              console.log("Parsed JSON result in JSP (Suggest):", result);
            } catch (e) {
              console.error("Failed to parse JSON response from backend (Suggest):", e);
              console.error("Response text was (Suggest):", responseBodyText);
              quickReplySuggestionsContainer.innerHTML = `<button class="loading" disabled>제안 응답 처리 오류</button>`;
              return;
            }

            const suggestions = result.suggestions || [];

            quickReplySuggestionsContainer.innerHTML = '';
            if (suggestions.length > 0) {
              suggestions.slice(0, 3).forEach(reply => {
                const button = document.createElement('button');
                button.textContent = reply;
                button.addEventListener('click', () => {
                  messageInput.value = reply;
                  messageInput.focus();
                  messageInput.dispatchEvent(new Event('input'));
                  quickReplySuggestionsContainer.innerHTML = '';
                });
                quickReplySuggestionsContainer.appendChild(button);
              });
            } else {
              quickReplySuggestionsContainer.innerHTML = `<button class="loading" disabled>제안 없음</button>`;
            }

          } catch (error) {
            console.error('빠른 답변 제안 실패:', error);
            quickReplySuggestionsContainer.innerHTML = `<button class="loading" disabled>제안 실패</button>`;
          } finally {
            suggestReplyBtn.classList.remove('loading');
            suggestReplyBtn.disabled = false;
          }
        });
        newChatBtn.addEventListener('click', () => {
          saveChatSession();

          chatHistory = [];
          currentChatId = null;

          chatContent.innerHTML = '';
          if (initialPrompt) {
            if (!chatContent.contains(initialPrompt)) {
              chatContent.appendChild(initialPrompt);
            }
            initialPrompt.style.display = 'block';
          }
          messageInput.value = '';
          messageInput.style.height = 'auto';
          messageInput.dispatchEvent(new Event('input'));
          quickReplySuggestionsContainer.innerHTML = '';

          console.log("새 채팅 시작됨");
        });
        function updateSidebarHistory(firstQuery) {
          // 이 함수는 더 이상 사용하지 않음 - updateSidebarHistoryFromStorage로 대체됨
          console.log("updateSidebarHistory 호출됨 (더 이상 사용하지 않음):", firstQuery);
        }

        document.addEventListener('DOMContentLoaded', () => {
          checkScreenSize();
          messageInput.dispatchEvent(new Event('input'));

          updateSidebarHistoryFromStorage();

          if (chatContent.children.length === 1 && chatContent.firstChild.id === 'initialPrompt') {
            initialPrompt.style.display = 'block';
          } else if (chatContent.children.length === 0 && initialPrompt) {
            chatContent.appendChild(initialPrompt);
            initialPrompt.style.display = 'block';
          }
        });
      </script>
    </body>

    </html>
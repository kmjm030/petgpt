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

      <link rel="stylesheet" href="<c:url value='/css/petgpt.css'/>">
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
          <div class="chat-model-selector" id="modelSelector">
            PetGPT AI <i class="fa-solid fa-chevron-down"></i>
          </div>
          <div class="chat-header-actions">
            <button class="action-btn gemini-btn" id="summarizeChatBtn" title="✨ 대화 요약하기">
              <span class="gemini-icon">✨</span> <span>요약</span>
            </button>

            <div class="user-profile" title="프로필">
              <div class="user-profile-icon"><span>펫</span></div>
              <%-- <span class="user-profile-plus">PLUS</span> --%>
            </div>
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
            <textarea id="messageInput" placeholder="PetGPT에게 무엇이든 물어보세요 (Shift+Enter로 줄바꿈)" rows="1"></textarea>
            <button class="icon-btn gemini-btn" id="suggestReplyBtn" title="✨ 빠른 답변 제안받기">
              <span class="gemini-icon">✨</span>
            </button>
            <button class="icon-btn" title="음성으로 입력" id="micBtn" style="display: none;">
              <i class="fa-solid fa-microphone"></i>
            </button>
            <button class="icon-btn send-btn" id="sendButton" title="보내기">
              <i class="fa-solid fa-arrow-up"></i>
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
        const summarizeChatBtn = document.getElementById('summarizeChatBtn');
        const summaryModal = document.getElementById('summaryModal');
        const closeSummaryModalBtn = document.getElementById('closeSummaryModal');
        const summaryModalBody = document.getElementById('summaryModalBody');
        const suggestReplyBtn = document.getElementById('suggestReplyBtn');
        const quickReplySuggestionsContainer = document.getElementById('quickReplySuggestions');
        const newChatBtn = document.getElementById('newChatBtn');

        let chatHistory = [];

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
          console.log("[displayMessage] Text:", text ? text.substring(0, 50) + "..." : "N/A");
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
            messageTextDiv.innerHTML = '<div class="loading-dots"><span></span><span></span><span></span></div>'; // 템플릿 리터럴 아니어도 되는 부분
          } else {
            const cleanedText = cleanResponseText(text);
            let finalHtml = cleanedText.replace(/\n/g, '<br>');

            if (role === 'model' && sourceDocuments && sourceDocuments.length > 0) {
              console.log("[displayMessage] Processing source documents, Count:", sourceDocuments.length);
              let sourcesHtml = '<div class="sources-info"><strong>출처:</strong><ul>';

              sourceDocuments.forEach((doc, index) => {
                // --- 루프 내부 상세 디버깅 로그 (템플릿 리터럴 미사용) ---
                console.log("Current index type:", typeof index, "Current index value:", index); // index 직접 확인
                console.log("[displayMessage] Loop[" + index + "] - doc object:", JSON.parse(JSON.stringify(doc)));

                const metadata = doc.metadata || {};
                const pageContent = doc.page_content || "";

                console.log("[displayMessage] Loop[" + index + "] - metadata object:", JSON.parse(JSON.stringify(metadata)));
                console.log("[displayMessage] Loop[" + index + "] - pageContent (first 30 chars):", pageContent.substring(0, 30));

                const sourceName = metadata.source ? metadata.source : '정보 출처';
                console.log("[displayMessage] Loop[" + index + "] - sourceName: '" + sourceName + "'");

                let displayText = "N/A";
                if (metadata.title) {
                  displayText = metadata.title;
                } else if (metadata.item_name) {
                  displayText = metadata.item_name;
                } else {
                  displayText = sourceName;
                }
                displayText = displayText || '제목 없음';
                console.log("[displayMessage] Loop[" + index + "] - displayText: '" + displayText + "'");

                let contentPreview = "";
                if (pageContent) {
                  contentPreview = " (" + pageContent.substring(0, 30) + "...)"; // 앞뒤 공백 주의
                }
                console.log("[displayMessage] Loop[" + index + "] - contentPreview: '" + contentPreview + "'");

                let currentLiHtml = "";
                if (metadata.source && typeof metadata.source === 'string' && metadata.source.startsWith('http')) {
                  // 문자열 연결로 HTML 생성
                  currentLiHtml = "<li><a href=\"" + metadata.source + "\" target=\"_blank\" rel=\"noopener noreferrer\">" + displayText + "</a>" + contentPreview + "</li>";
                } else {
                  if (displayText !== 'N/A' || contentPreview !== "") {
                    currentLiHtml = "<li>" + displayText + contentPreview + "</li>";
                  } else {
                    currentLiHtml = "<li>출처 정보 없음</li>";
                  }
                }
                console.log("[displayMessage] Loop[" + index + "] - currentLiHtml:", currentLiHtml);
                sourcesHtml += currentLiHtml;
                // --- 루프 내부 상세 디버깅 로그 끝 ---
              });

              sourcesHtml += '</ul></div>';
              console.log("[displayMessage] Generated sourcesHtml:", sourcesHtml);
              finalHtml += sourcesHtml;
            }
            messageTextDiv.innerHTML = finalHtml;
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

          displayMessage('user', messageText);
          chatHistory.push({ role: 'user', parts: [{ text: messageText }] });

          updateSidebarHistory(messageText);

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

            const aiResponseText = result.result || "응답을 받지 못했습니다.";
            const sourceDocs = result.source_documents || [];
            console.log("Source documents received in JSP (Chat):", sourceDocs);

            displayMessage('model', aiResponseText, false, sourceDocs);
            chatHistory.push({ role: 'model', parts: [{ text: aiResponseText }] });

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

        summarizeChatBtn.addEventListener('click', async () => {
          if (chatHistory.length === 0) {
            const tempMsg = document.createElement('div');
            tempMsg.textContent = "요약할 대화 내용이 없습니다.";
            tempMsg.style.cssText = "position:fixed; top:20px; left:50%; transform:translateX(-50%); background:var(--input-bg); padding:10px 20px; border-radius:5px; box-shadow:0 2px 5px rgba(0,0,0,0.2); z-index:1001;";
            document.body.appendChild(tempMsg);
            setTimeout(() => tempMsg.remove(), 3000);
            return;
          }

          summaryModal.style.display = 'flex';
          summaryModalBody.innerHTML = `<div class="loading-indicator"><i class="fas fa-spinner fa-spin"></i> 요약하는 중...</div>`;
          summarizeChatBtn.disabled = true;

          try {
            const conversationText = chatHistory.map(msg =>
              `${msg.role == 'user' ? '사용자' : 'AI'}: ${msg.parts[0].text} `
            ).join('\n\n');

            const response = await fetch('<c:url value="/api/summarize"/>', {
              method: 'POST',
              headers: { 'Content-Type': 'application/json' },
              body: JSON.stringify({ conversation_text: conversationText })
            });

            if (!response.ok) {
              let errorMsg = `API 요약 오류 (${response.status}): ${response.statusText}`;
              const responseText = await response.text();
              console.error('Summarize API Error (Text):', responseText);
              try {
                const errorData = JSON.parse(responseText);
                errorMsg += ` - ${errorData.error || JSON.stringify(errorData)}`;
              } catch (e) {
                errorMsg += ` - ${responseText || '내용 없음'}`;
              }
              throw new Error(errorMsg);
            }

            const responseBodyText = await response.text();
            console.log("Raw response body text from Spring backend (Summarize):", responseBodyText);

            let result;
            try {
              result = JSON.parse(responseBodyText);
              console.log("Parsed JSON result in JSP (Summarize):", result);
            } catch (e) {
              console.error("Failed to parse JSON response from backend (Summarize):", e);
              console.error("Response text was (Summarize):", responseBodyText);
              summaryModalBody.textContent = "요약 응답 처리 중 오류가 발생했습니다. (JSON 파싱 실패)";
              return;
            }

            summaryModalBody.textContent = result.summary || "요약을 생성할 수 없습니다.";

          } catch (error) {
            console.error('요약 실패:', error);
            summaryModalBody.textContent = `요약 실패: ${error.message}`;
          } finally {
            summarizeChatBtn.disabled = false;
          }
        });
        closeSummaryModalBtn.addEventListener('click', () => summaryModal.style.display = 'none');
        window.addEventListener('click', (event) => {
          if (event.target == summaryModal) {
            summaryModal.style.display = 'none';
          }
        });

        suggestReplyBtn.addEventListener('click', async () => {
          const lastAiMessage = chatHistory.filter(msg => msg.role == 'model').pop();
          if (!lastAiMessage) {
            quickReplySuggestionsContainer.innerHTML = `< button class="loading" disabled > AI 응답이 없습니다.</button > `;
            return;
          }
          const contextMessage = lastAiMessage.parts[0].text;

          quickReplySuggestionsContainer.innerHTML = `< button class="loading" disabled > <i class="fas fa-spinner fa-spin"></i> 제안 로딩 중...</button > `;
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
              quickReplySuggestionsContainer.innerHTML = `< button class= "loading" disabled > 제안 없음</button > `;
            }

          } catch (error) {
            console.error('빠른 답변 제안 실패:', error);
            quickReplySuggestionsContainer.innerHTML = `< button class= "loading" disabled > 제안 실패</button > `;
          } finally {
            suggestReplyBtn.classList.remove('loading');
            suggestReplyBtn.disabled = false;
          }
        });

        newChatBtn.addEventListener('click', () => {
          chatHistory = [];
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
          document.getElementById('historyToday').innerHTML = '';
          console.log("새 채팅 시작됨");
        });

        function updateSidebarHistory(firstQuery) {
          const historyTodayList = document.getElementById('historyToday');
          if (historyTodayList.children.length >= 5) {
            historyTodayList.removeChild(historyTodayList.lastChild);
          }

          const listItem = document.createElement('li');
          const link = document.createElement('a');
          link.href = "#";
          const displayMessage = firstQuery.length > 20 ? firstQuery.substring(0, 17) + "..." : firstQuery;
          link.innerHTML = `< span class= "link-text" > ${displayMessage}</span >`;
          link.addEventListener('click', (e) => {
            e.preventDefault();
            console.log("선택된 채팅 기록 로드 기능은 아직 구현되지 않았습니다:", firstQuery);
            alert("선택한 채팅 불러오기 기능은 아직 개발 중입니다.");
          });
          listItem.appendChild(link);
          if (historyTodayList.firstChild) {
            historyTodayList.insertBefore(listItem, historyTodayList.firstChild);
          } else {
            historyTodayList.appendChild(listItem);
          }
        }

        document.addEventListener('DOMContentLoaded', () => {
          checkScreenSize();
          messageInput.dispatchEvent(new Event('input'));
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
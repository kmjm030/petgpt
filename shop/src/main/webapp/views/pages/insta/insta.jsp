<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<!DOCTYPE html>
<html lang="ko">

<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Instagram</title>
    <link rel="stylesheet" href="<c:url value='/css/insta.css'/>">
    <!-- Font Awesome (아이콘 사용 시) -->
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.0.0-beta3/css/all.min.css">
</head>

<body>
    <!-- 1. Header -->
    <header>
        <div class="container">
            <img src="<c:url value='/img/insta/logo.png'/>" alt="Instagram Logo" class="logo">
            <div class="search-bar">
                <input type="text" placeholder="검색">
            </div>
            <nav class="nav-icons">
                <a href="#"><i class="fas fa-home"></i></a>
                <a href="#"><i class="fab fa-facebook-messenger"></i></a>
                <a href="#"><i class="far fa-plus-square"></i></a>
                <a href="#"><i class="far fa-compass"></i></a>
                <a href="#"><i class="far fa-heart"></i></a>
                <a href="#"><img src="<c:url value='/img/insta/profile-pic-small.png'/>" alt="Profile" class="profile-icon"></a>
            </nav>
        </div>
    </header>

    <!-- 2. Main Content -->
    <main>
        <div class="container">
            <div class="content-area">
                <!-- 2.1 Stories -->
                <section class="stories">
                    <!-- 스토리 아이템 예시 (JS로 동적 생성 가능) -->
                    <div class="story">
                        <img src="<c:url value='/img/insta/story-profile1.jpg'/>" alt="Story 1">
                        <span>username1</span>
                    </div>
                    <div class="story">
                        <img src="<c:url value='/img/insta/story-profile2.jpg'/>" alt="Story 2">
                        <span>username2</span>
                    </div>
                    <div class="story">
                        <img src="<c:url value='/img/insta/story-profile3.jpg'/>" alt="Story 3">
                        <span>username3</span>
                    </div>
                </section>

                <!-- 2.2 Feed -->
                <section class="feed">
                    <!-- 게시물 카드 예시 (JS로 동적 생성 가능) -->
                    <article class="post">
                        <div class="post-header">
                            <img src="<c:url value='/img/insta/post-profile1.png'/>" alt="User Profile" class="post-profile-pic">
                            <span class="post-username">user_name_official</span>
                            <button class="options-button">...</button>
                        </div>
                        <div class="post-image">
                            <img src="<c:url value='/img/insta/post-image1.png'/>" alt="Post Image">
                        </div>
                        <div class="post-actions">
                            <button><i class="far fa-heart"></i></button>
                            <button><i class="far fa-comment"></i></button>
                            <button><i class="far fa-paper-plane"></i></button>
                            <button class="bookmark-button"><i class="far fa-bookmark"></i></button>
                        </div>
                        <div class="post-likes">
                            좋아요 <span class="like-count">1,234</span>개
                        </div>
                        <div class="post-caption">
                            <span class="post-username">user_name_official</span>
                            멋진 하루! #일상 #여행
                        </div>
                        <div class="post-comments-link">
                            댓글 <span class="comment-count">56</span>개 모두 보기
                        </div>
                        <div class="post-timestamp">
                            1시간 전
                        </div>
                        <div class="add-comment">
                            <input type="text" placeholder="댓글 달기...">
                            <button>게시</button>
                        </div>
                    </article>
                    <article class="post">
                        <div class="post-header">
                            <img src="<c:url value='/img/insta/post-profile2.png'/>" alt="User Profile" class="post-profile-pic">
                            <span class="post-username">user_name_official</span>
                            <button class="options-button">...</button>
                        </div>
                        <div class="post-image">
                            <img src="<c:url value='/img/insta/post-image2.png'/>" alt="Post Image">
                        </div>
                        <div class="post-actions">
                            <button><i class="far fa-heart"></i></button>
                            <button><i class="far fa-comment"></i></button>
                            <button><i class="far fa-paper-plane"></i></button>
                            <button class="bookmark-button"><i class="far fa-bookmark"></i></button>
                        </div>
                        <div class="post-likes">
                            좋아요 <span class="like-count">1,234</span>개
                        </div>
                        <div class="post-caption">
                            <span class="post-username">user_name_official</span>
                            멋진 하루! #일상 #여행
                        </div>
                        <div class="post-comments-link">
                            댓글 <span class="comment-count">56</span>개 모두 보기
                        </div>
                        <div class="post-timestamp">
                            1시간 전
                        </div>
                        <div class="add-comment">
                            <input type="text" placeholder="댓글 달기...">
                            <button>게시</button>
                        </div>
                    </article>
                    <article class="post">
                        <div class="post-header">
                            <img src="<c:url value='/img/insta/post-profile3.png'/>" alt="User Profile" class="post-profile-pic">
                            <span class="post-username">user_name_official</span>
                            <button class="options-button">...</button>
                        </div>
                        <div class="post-image">
                            <img src="<c:url value='/img/insta/post-image3.png'/>" alt="Post Image">
                        </div>
                        <div class="post-actions">
                            <button><i class="far fa-heart"></i></button>
                            <button><i class="far fa-comment"></i></button>
                            <button><i class="far fa-paper-plane"></i></button>
                            <button class="bookmark-button"><i class="far fa-bookmark"></i></button>
                        </div>
                        <div class="post-likes">
                            좋아요 <span class="like-count">1,234</span>개
                        </div>
                        <div class="post-caption">
                            <span class="post-username">user_name_official</span>
                            멋진 하루! #일상 #여행
                        </div>
                        <div class="post-comments-link">
                            댓글 <span class="comment-count">56</span>개 모두 보기
                        </div>
                        <div class="post-timestamp">
                            1시간 전
                        </div>
                        <div class="add-comment">
                            <input type="text" placeholder="댓글 달기...">
                            <button>게시</button>
                        </div>
                    </article>
                    <article class="post">
                        <div class="post-header">
                            <img src="<c:url value='/img/insta/post-profile1.png'/>" alt="User Profile" class="post-profile-pic">
                            <span class="post-username">user_name_official</span>
                            <button class="options-button">...</button>
                        </div>
                        <div class="post-image">
                            <img src="<c:url value='/img/insta/post-image4.png'/>" alt="Post Image">
                        </div>
                        <div class="post-actions">
                            <button><i class="far fa-heart"></i></button>
                            <button><i class="far fa-comment"></i></button>
                            <button><i class="far fa-paper-plane"></i></button>
                            <button class="bookmark-button"><i class="far fa-bookmark"></i></button>
                        </div>
                        <div class="post-likes">
                            좋아요 <span class="like-count">1,234</span>개
                        </div>
                        <div class="post-caption">
                            <span class="post-username">user_name_official</span>
                            멋진 하루! #일상 #여행
                        </div>
                        <div class="post-comments-link">
                            댓글 <span class="comment-count">56</span>개 모두 보기
                        </div>
                        <div class="post-timestamp">
                            1시간 전
                        </div>
                        <div class="add-comment">
                            <input type="text" placeholder="댓글 달기...">
                            <button>게시</button>
                        </div>
                    </article>
                    <article class="post">
                        <div class="post-header">
                            <img src="<c:url value='/img/insta/post-profile2.png'/>" alt="User Profile" class="post-profile-pic">
                            <span class="post-username">user_name_official</span>
                            <button class="options-button">...</button>
                        </div>
                        <div class="post-image">
                            <img src="<c:url value='/img/insta/post-image5.png'/>" alt="Post Image">
                        </div>
                        <div class="post-actions">
                            <button><i class="far fa-heart"></i></button>
                            <button><i class="far fa-comment"></i></button>
                            <button><i class="far fa-paper-plane"></i></button>
                            <button class="bookmark-button"><i class="far fa-bookmark"></i></button>
                        </div>
                        <div class="post-likes">
                            좋아요 <span class="like-count">1,234</span>개
                        </div>
                        <div class="post-caption">
                            <span class="post-username">user_name_official</span>
                            멋진 하루! #일상 #여행
                        </div>
                        <div class="post-comments-link">
                            댓글 <span class="comment-count">56</span>개 모두 보기
                        </div>
                        <div class="post-timestamp">
                            1시간 전
                        </div>
                        <div class="add-comment">
                            <input type="text" placeholder="댓글 달기...">
                            <button>게시</button>
                        </div>
                    </article>
                    <article class="post">
                        <div class="post-header">
                            <img src="<c:url value='/img/insta/post-profile3.png'/>" alt="User Profile" class="post-profile-pic">
                            <span class="post-username">user_name_official</span>
                            <button class="options-button">...</button>
                        </div>
                        <div class="post-image">
                            <img src="<c:url value='/img/insta/post-image6.png'/>" alt="Post Image">
                        </div>
                        <div class="post-actions">
                            <button><i class="far fa-heart"></i></button>
                            <button><i class="far fa-comment"></i></button>
                            <button><i class="far fa-paper-plane"></i></button>
                            <button class="bookmark-button"><i class="far fa-bookmark"></i></button>
                        </div>
                        <div class="post-likes">
                            좋아요 <span class="like-count">1,234</span>개
                        </div>
                        <div class="post-caption">
                            <span class="post-username">user_name_official</span>
                            멋진 하루! #일상 #여행
                        </div>
                        <div class="post-comments-link">
                            댓글 <span class="comment-count">56</span>개 모두 보기
                        </div>
                        <div class="post-timestamp">
                            1시간 전
                        </div>
                        <div class="add-comment">
                            <input type="text" placeholder="댓글 달기...">
                            <button>게시</button>
                        </div>
                    </article>
                </section>
            </div>

            <!-- (선택) 2.3 Sidebar (데스크탑 뷰) -->
            <aside class="sidebar">
                <div class="sidebar-user">
                    <img src="<c:url value='/img/insta/profile-pic-small.png'/>" alt="My Profile">
                    <div>
                        <p class="username">my_username</p>
                        <p class="fullname">내 이름</p>
                    </div>
                    <button>전환</button>
                </div>
                <div class="suggestions">
                    <div class="suggestions-header">
                        <span>회원님을 위한 추천</span>
                        <a href="#">모두 보기</a>
                    </div>
                    <!-- 추천 아이템 예시 -->
                    <div class="suggestion-item">
                        <img src="<c:url value='/img/insta/suggestion-profile1.png'/>" alt="Suggestion">
                        <div>
                            <p class="username">suggested_user1</p>
                            <p class="subtext">회원님을 위한 추천</p>
                        </div>
                        <button>팔로우</button>
                    </div>
                    <!-- ... 더 많은 추천 ... -->
                </div>
                <footer class="sidebar-footer">
                    <a href="#">소개</a> · <a href="#">도움말</a> · <a href="#">홍보 센터</a> · <a href="#">API</a> · <a
                        href="#">채용 정보</a> · <a href="#">개인정보처리방침</a> · <a href="#">약관</a> · <a href="#">위치</a> · <a
                        href="#">언어</a>
                    <p>© 2023 INSTAGRAM FROM META</p>
                </footer>
            </aside>
        </div>
    </main>

    <script src="<c:url value='/js/insta.js'/>"></script>
</body>

</html> 
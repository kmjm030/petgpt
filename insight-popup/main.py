import customtkinter as ctk

# CustomTkinter 외관 및 테마 설정
ctk.set_appearance_mode("System")  # "System", "Light", "Dark"
ctk.set_default_color_theme("dark-blue")  # "blue", "green", "dark-blue"

import time
import threading
import queue
from screen_capture import capture_screen_to_bytes
from ai_processor import get_ai_response_based_on_screen_description
from display_bubble import SpeechBubble
import tkinter as tk

CAPTURE_INTERVAL_SECONDS = 20
bubble = None
message_queue = queue.Queue()
stop_event = threading.Event()
main_timer_thread = None


def periodic_task():
    global main_timer_thread
    print(f"{time.ctime()}: 주기적 작업 시작")

    image_data = capture_screen_to_bytes()
    if image_data:
        current_chat_history_for_main = []
        ai_text = get_ai_response_based_on_screen_description(
            image_data,
            chat_history_frontend=current_chat_history_for_main,  # 프론트엔드 형식으로 전달
        )
        print(f"AI (이미지 설명+RAG) 어시스턴트 답변: {ai_text}")  # 로그 메시지 변경
        if ai_text:
            message_queue.put(ai_text)
    else:
        print("이미지 캡쳐 실패, AI 분석 건너뜀")

    if not stop_event.is_set():
        main_timer_thread = threading.Timer(CAPTURE_INTERVAL_SECONDS, periodic_task)
        main_timer_thread.daemon = True
        main_timer_thread.start()
    else:
        print("주기적 작업 타이머 중단됨.")


def check_message_queue(root_tk, bubble_instance):
    try:
        while not message_queue.empty():
            message = message_queue.get_nowait()
            if bubble_instance:
                bubble_instance.show_message(message)
            message_queue.task_done()
    except queue.Empty:
        pass
    except Exception as e:
        print(f"메시지 큐 처리 중 오류: {e}")
        if (
            bubble_instance
            and bubble_instance.root
            and not bubble_instance.root.winfo_exists()
        ):
            print("말풍선 윈도우가 존재하지 않아 메시지를 표시할 수 없습니다.")

    if not stop_event.is_set() and root_tk.winfo_exists():
        root_tk.after(100, lambda: check_message_queue(root_tk, bubble_instance))


def main():
    global bubble
    global main_timer_thread

    root_tk = tk.Tk()
    root_tk.withdraw()

    bubble = SpeechBubble()

    main_timer_thread = threading.Timer(1, periodic_task)
    main_timer_thread.daemon = True
    main_timer_thread.start()
    print(
        f"{CAPTURE_INTERVAL_SECONDS}초 간격으로 화면 분석을 시작합니다. (Ctrl+C로 종료)"
    )

    check_message_queue(root_tk, bubble)

    try:
        while not stop_event.is_set():
            root_tk.update_idletasks()
            root_tk.update()
            time.sleep(0.01)

    except KeyboardInterrupt:
        print("\n프로그램 종료 중 (KeyboardInterrupt)...")
    finally:
        print("프로그램 종료 절차 시작...")
        stop_event.set()

        if main_timer_thread and main_timer_thread.is_alive():
            # Timer는 cancel() 메소드로 직접 취소할 수 있습니다.
            # 하지만 daemon 스레드이므로 메인 종료 시 알아서 정리될 수도 있습니다.
            # 명시적으로 취소하려면 periodic_task 내부에서 다음 Timer를 시작하기 전에
            # stop_event를 확인하는 것 외에, main_timer_thread.cancel()을 호출할 수 있어야 합니다.
            # 현재 구조에서는 stop_event로 자연스럽게 다음 Timer가 생성되지 않도록 합니다.
            print("실행 중인 타이머 작업이 있다면 종료 대기 중...")
            # main_timer_thread.join(timeout=5) # 이미 daemon이므로 필수는 아님

        if bubble:
            print("말풍선 닫는 중...")
            bubble.close()
        if root_tk and root_tk.winfo_exists():
            root_tk.destroy()
        print("프로그램이 종료되었습니다.")


if __name__ == "__main__":
    main()

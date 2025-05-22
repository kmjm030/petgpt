import customtkinter as ctk
import tkinter as tk
from screeninfo import get_monitors


class SpeechBubble:
    def __init__(self):
        self.root = None
        self.label_frame = None
        self.label = None

        self.bubble_font_family = "Noto Sans KR"
        self.bubble_font_size = 16
        self.bubble_font_weight = "bold"
        self.bubble_font_slant = "roman"

        self.bubble_font = ctk.CTkFont(
            family=self.bubble_font_family,
            size=self.bubble_font_size,
            weight=self.bubble_font_weight,
            slant=self.bubble_font_slant,
        )

        self.bubble_fg_color = ("#F9F9F9", "#282828")
        self.text_color = ("#222222", "#DCE4EE")
        self.corner_radius = 10
        self.padding_x = 15
        self.padding_y = 10
        self.max_bubble_width = 400

        self.hide_timer = None
        self._primary_monitor_geometry = None

    def _get_primary_monitor_geometry(self):
        if self._primary_monitor_geometry is None:
            monitors = get_monitors()
            primary_monitor = None
            if monitors:
                for m in monitors:
                    if m.is_primary:
                        primary_monitor = m
                        break
                if not primary_monitor:
                    primary_monitor = monitors[0]
            self._primary_monitor_geometry = primary_monitor
        return self._primary_monitor_geometry

    def _setup_window(self):
        if self.root and self.root.winfo_exists():
            self.root.destroy()

        self.root = ctk.CTkToplevel()
        self.root.overrideredirect(True)
        self.root.wm_attributes("-topmost", True)

        self.label_frame = ctk.CTkFrame(
            self.root, corner_radius=self.corner_radius, fg_color=self.bubble_fg_color
        )
        self.label_frame.pack(expand=True, fill="both")

        self.label = ctk.CTkLabel(
            self.label_frame,
            text="",
            font=self.bubble_font,
            text_color=self.text_color,
            wraplength=self.max_bubble_width - (self.padding_x * 2),
            justify="left",
            anchor="nw",
        )
        self.label.pack(
            expand=True, fill="both", padx=self.padding_x, pady=self.padding_y
        )

    def show_message(self, message, duration_ms=7000):
        if not self.root or not self.root.winfo_exists():
            self._setup_window()
            if not self.root:
                print("윈도우 생성 실패")
                return

        self.label.configure(text=message)
        self.label.update_idletasks()

        req_width = self.label_frame.winfo_reqwidth()
        req_height = self.label_frame.winfo_reqheight()

        window_width = min(
            req_width, self.max_bubble_width + self.padding_x * 2
        )  # 패딩 고려
        window_height = req_height

        primary_monitor = self._get_primary_monitor_geometry()
        margin = 20

        if primary_monitor:
            x_pos = primary_monitor.x + margin
            y_pos = primary_monitor.y + margin
        else:
            print(
                "경고: 주 모니터 정보를 가져올 수 없습니다. 기본 화면 기준으로 위치합니다."
            )
            x_pos = margin
            y_pos = margin

        self.root.geometry(f"{window_width}x{window_height}+{x_pos}+{y_pos}")
        self.root.deiconify()

        if self.hide_timer:
            self.root.after_cancel(self.hide_timer)
        self.hide_timer = self.root.after(duration_ms, self.hide)

    def hide(self):
        if self.root and self.root.winfo_exists():
            self.root.withdraw()

    def close(self):
        if self.hide_timer:
            try:
                if self.root and self.root.winfo_exists():
                    self.root.after_cancel(self.hide_timer)
            except tk.TclError:
                pass
            except Exception:
                pass
        if self.root and self.root.winfo_exists():
            self.root.destroy()
        self.root = None

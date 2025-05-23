import customtkinter as ctk
import tkinter as tk
from screeninfo import get_monitors
from PIL import Image
import os


class SpeechBubble:
    def __init__(self):
        self.root = None
        self.label_frame = None
        self.message_label = None
        self.profile_frame = None
        self.profile_image_label = None
        self.profile_name_label = None

        # 폰트 설정
        self.name_font_family = "Noto Sans KR"
        self.name_font_size = 12
        self.name_font_weight = "bold"

        self.message_font_family = "Noto Sans KR"
        self.message_font_size = 14
        self.message_font_weight = "normal"
        self.message_font_slant = "roman"

        self.name_font = ctk.CTkFont(
            family=self.name_font_family,
            size=self.name_font_size,
            weight=self.name_font_weight,
        )

        self.message_font = ctk.CTkFont(
            family=self.message_font_family,
            size=self.message_font_size,
            weight=self.message_font_weight,
            slant=self.message_font_slant,
        )

        # 색상 설정
        self.bubble_fg_color = "#FEE500"  # 노란색 말풍선
        self.text_color = "#000000"  # 검은색 텍스트
        self.name_color = "#333333"  # 이름 색상

        # 프로필 설정
        self.profile_name = "AI 어시스턴트"
        self.profile_image_size = 36

        self.corner_radius = 20
        self.padding_x = 12
        self.padding_y = 8
        self.max_bubble_width = 400

        script_dir = os.path.dirname(os.path.abspath(__file__))
        profile_img_path = os.path.join(script_dir, "assets", "profile.png")

        self.profile_image = None
        try:
            if os.path.exists(profile_img_path):
                img = Image.open(profile_img_path)
                self.profile_image = ctk.CTkImage(
                    light_image=img,
                    dark_image=img,
                    size=(self.profile_image_size, self.profile_image_size),
                )
        except Exception as e:
            print(f"프로필 이미지 로드 실패: {e}")

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
            self.root,
            corner_radius=self.corner_radius,
            fg_color=self.bubble_fg_color,
            border_width=0,
        )
        self.label_frame.pack(expand=True, fill="both", padx=0, pady=0)

        self.profile_frame = ctk.CTkFrame(
            self.label_frame, fg_color="transparent", border_width=0
        )
        self.profile_frame.pack(fill="x", padx=self.padding_x, pady=(self.padding_y, 2))

        if self.profile_image:
            self.profile_image_label = ctk.CTkLabel(
                self.profile_frame,
                text="",
                image=self.profile_image,
                width=self.profile_image_size,
                height=self.profile_image_size,
            )
            self.profile_image_label.pack(side="left", padx=(0, 8))
        else:
            empty_frame = ctk.CTkFrame(
                self.profile_frame,
                width=self.profile_image_size,
                height=self.profile_image_size,
                fg_color=self.bubble_fg_color,
            )
            empty_frame.pack(side="left", padx=(0, 8))
            empty_frame.pack_propagate(False)

        self.profile_name_label = ctk.CTkLabel(
            self.profile_frame,
            text=self.profile_name,
            font=self.name_font,
            text_color=self.name_color,
            anchor="w",
        )
        self.profile_name_label.pack(side="left", fill="x", expand=True)

        self.message_label = ctk.CTkLabel(
            self.label_frame,
            text="",
            font=self.message_font,
            text_color=self.text_color,
            wraplength=self.max_bubble_width - (self.padding_x * 2),
            justify="left",
            anchor="nw",
        )
        self.message_label.pack(
            fill="both", padx=self.padding_x, pady=(0, self.padding_y)
        )

    def show_message(self, message, duration_ms=30000):
        if not self.root or not self.root.winfo_exists():
            self._setup_window()
            if not self.root:
                print("윈도우 생성 실패")
                return

        self.message_label.configure(text=message)
        self.message_label.update_idletasks()

        req_width = self.label_frame.winfo_reqwidth()
        req_height = self.label_frame.winfo_reqheight()

        window_width = min(req_width, self.max_bubble_width)
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

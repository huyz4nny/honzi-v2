import docx
from docx.shared import Inches, Pt, RGBColor
from docx.enum.text import WD_ALIGN_PARAGRAPH
from docx.enum.table import WD_TABLE_ALIGNMENT
from docx.oxml import parse_xml
from docx.oxml.ns import nsdecls
import os

def create_document():
    doc = docx.Document()

    # Set page margins (1 inch / 2.54 cm all around)
    for section in doc.sections:
        section.top_margin = Inches(1.0)
        section.bottom_margin = Inches(1.0)
        section.left_margin = Inches(1.0)
        section.right_margin = Inches(1.0)
        section.different_first_page_header_footer = True
        
        # Header & Footer for subsequent pages
        header = section.header
        hp = header.paragraphs[0]
        hp.alignment = WD_ALIGN_PARAGRAPH.RIGHT
        hrun = hp.add_run("HanziGo - Hướng Dẫn Cài Đặt & Chạy Ứng Dụng Web (PRJ301)")
        hrun.font.name = "Segoe UI"
        hrun.font.size = Pt(8.5)
        hrun.font.color.rgb = RGBColor(140, 140, 140)

        footer = section.footer
        fp = footer.paragraphs[0]
        fp.alignment = WD_ALIGN_PARAGRAPH.CENTER
        frun = fp.add_run("— Tài liệu hướng dẫn triển khai dự án HanziGo | Java Web Application —")
        frun.font.name = "Segoe UI"
        frun.font.size = Pt(8.5)
        frun.font.color.rgb = RGBColor(140, 140, 140)

    # Styles and Palette
    COLOR_PRIMARY = RGBColor(194, 58, 34)      # #C23A22 (Đỏ HanziGo)
    COLOR_SECONDARY = RGBColor(30, 41, 59)     # #1E293B (Slate Navy)
    COLOR_TEXT = RGBColor(40, 40, 40)          # #282828 (Dark Gray)
    COLOR_MUTED = RGBColor(100, 100, 100)      # #646464 (Muted Gray)
    COLOR_ACCENT = RGBColor(217, 119, 6)       # #D97706 (Amber/Gold)

    # Base Normal Style
    normal_style = doc.styles['Normal']
    normal_style.font.name = 'Segoe UI'
    normal_style.font.size = Pt(10.5)
    normal_style.font.color.rgb = COLOR_TEXT
    normal_style.paragraph_format.line_spacing = 1.2
    normal_style.paragraph_format.space_after = Pt(6)

    # Helper XML functions
    def set_cell_background(cell, hex_color):
        shading = parse_xml(f'<w:shd {nsdecls("w")} w:fill="{hex_color}"/>')
        cell._tc.get_or_add_tcPr().append(shading)

    def set_cell_margins(cell, top=120, bottom=120, left=180, right=180):
        tcPr = cell._tc.get_or_add_tcPr()
        tcMar = parse_xml(f'<w:tcMar {nsdecls("w")}>'
                          f'<w:top w:w="{top}" w:type="dxa"/>'
                          f'<w:bottom w:w="{bottom}" w:type="dxa"/>'
                          f'<w:left w:w="{left}" w:type="dxa"/>'
                          f'<w:right w:w="{right}" w:type="dxa"/>'
                          f'</w:tcMar>')
        tcPr.append(tcMar)

    def set_cell_borders(cell, top=None, bottom=None, left=None, right=None):
        tcPr = cell._tc.get_or_add_tcPr()
        borders = parse_xml(f'<w:tcBorders {nsdecls("w")}>'
                            f'<w:top w:val="{top.get("val","single") if top else "none"}" w:sz="{top.get("sz","4") if top else "0"}" w:space="0" w:color="{top.get("color","auto") if top else "auto"}"/>'
                            f'<w:bottom w:val="{bottom.get("val","single") if bottom else "none"}" w:sz="{bottom.get("sz","4") if bottom else "0"}" w:space="0" w:color="{bottom.get("color","auto") if bottom else "auto"}"/>'
                            f'<w:left w:val="{left.get("val","single") if left else "none"}" w:sz="{left.get("sz","4") if left else "0"}" w:space="0" w:color="{left.get("color","auto") if left else "auto"}"/>'
                            f'<w:right w:val="{right.get("val","single") if right else "none"}" w:sz="{right.get("sz","4") if right else "0"}" w:space="0" w:color="{right.get("color","auto") if right else "auto"}"/>'
                            f'</w:tcBorders>')
        tcPr.append(borders)

    def add_title(text, subtitle=None):
        p = doc.add_paragraph()
        p.alignment = WD_ALIGN_PARAGRAPH.CENTER
        p.paragraph_format.space_before = Pt(12)
        p.paragraph_format.space_after = Pt(4)
        run = p.add_run("汉 ")
        run.font.name = "Segoe UI"
        run.font.size = Pt(28)
        run.font.bold = True
        run.font.color.rgb = COLOR_PRIMARY
        
        run2 = p.add_run("HanziGo")
        run2.font.name = "Segoe UI"
        run2.font.size = Pt(28)
        run2.font.bold = True
        run2.font.color.rgb = COLOR_SECONDARY

        if subtitle:
            p_sub = doc.add_paragraph()
            p_sub.alignment = WD_ALIGN_PARAGRAPH.CENTER
            p_sub.paragraph_format.space_after = Pt(18)
            run_sub = p_sub.add_run(subtitle)
            run_sub.font.name = "Segoe UI"
            run_sub.font.size = Pt(13)
            run_sub.font.color.rgb = COLOR_MUTED
            run_sub.font.italic = True

    def add_h1(text):
        p = doc.add_paragraph()
        p.paragraph_format.space_before = Pt(18)
        p.paragraph_format.space_after = Pt(8)
        p.paragraph_format.keep_with_next = True
        run = p.add_run(text)
        run.font.name = "Segoe UI"
        run.font.size = Pt(15)
        run.font.bold = True
        run.font.color.rgb = COLOR_PRIMARY
        
        # Bottom accent line under H1
        pBdr = parse_xml(f'<w:pBdr {nsdecls("w")}><w:bottom w:val="single" w:sz="12" w:space="4" w:color="C23A22"/></w:pBdr>')
        p._p.get_or_add_pPr().append(pBdr)

    def add_h2(text):
        p = doc.add_paragraph()
        p.paragraph_format.space_before = Pt(12)
        p.paragraph_format.space_after = Pt(4)
        p.paragraph_format.keep_with_next = True
        run = p.add_run(text)
        run.font.name = "Segoe UI"
        run.font.size = Pt(12.5)
        run.font.bold = True
        run.font.color.rgb = COLOR_SECONDARY

    def add_callout(title, text, box_type="info"):
        table = doc.add_table(rows=1, cols=1)
        table.alignment = WD_TABLE_ALIGNMENT.CENTER
        cell = table.cell(0, 0)
        
        bg_colors = {
            "info": "F0F9FF",    # Light blue
            "warning": "FEF3C7", # Light amber
            "success": "ECFDF5", # Light green
            "note": "F8FAFC"     # Light slate
        }
        border_colors = {
            "info": "0284C7",
            "warning": "D97706",
            "success": "059669",
            "note": "C23A22"
        }
        bg = bg_colors.get(box_type, "F8FAFC")
        border = border_colors.get(box_type, "C23A22")

        set_cell_background(cell, bg)
        set_cell_margins(cell, top=140, bottom=140, left=200, right=160)
        set_cell_borders(cell, left={"val": "single", "sz": "24", "color": border})

        p = cell.paragraphs[0]
        p.paragraph_format.space_after = Pt(3)
        p.paragraph_format.line_spacing = 1.15
        run_t = p.add_run(f"📌 {title}\n")
        run_t.font.name = "Segoe UI"
        run_t.font.size = Pt(10.5)
        run_t.font.bold = True
        run_t.font.color.rgb = COLOR_SECONDARY

        run_txt = p.add_run(text)
        run_txt.font.name = "Segoe UI"
        run_txt.font.size = Pt(9.5)
        run_txt.font.color.rgb = COLOR_TEXT

        p_after = doc.add_paragraph()
        p_after.paragraph_format.space_after = Pt(4)

    def add_code_block(code_str):
        table = doc.add_table(rows=1, cols=1)
        table.alignment = WD_TABLE_ALIGNMENT.CENTER
        cell = table.cell(0, 0)
        set_cell_background(cell, "1E293B") # Dark slate
        set_cell_margins(cell, top=120, bottom=120, left=160, right=160)
        set_cell_borders(cell)

        p = cell.paragraphs[0]
        p.paragraph_format.space_after = Pt(0)
        p.paragraph_format.line_spacing = 1.15
        run = p.add_run(code_str)
        run.font.name = "Consolas"
        run.font.size = Pt(9)
        run.font.color.rgb = RGBColor(226, 232, 240) # Light white-blue

        p_after = doc.add_paragraph()
        p_after.paragraph_format.space_after = Pt(4)

    def format_table_headers_and_rows(table, headers, data, col_widths=None):
        table.alignment = WD_TABLE_ALIGNMENT.CENTER
        
        # Header Row
        hdr_cells = table.rows[0].cells
        for idx, text in enumerate(headers):
            hdr_cells[idx].text = text
            set_cell_background(hdr_cells[idx], "C23A22") # Red header
            set_cell_margins(hdr_cells[idx], top=120, bottom=120, left=140, right=140)
            set_cell_borders(hdr_cells[idx], bottom={"val": "single", "sz": "12", "color": "991B1B"})
            p = hdr_cells[idx].paragraphs[0]
            p.paragraph_format.space_after = Pt(0)
            p.alignment = WD_ALIGN_PARAGRAPH.LEFT
            for run in p.runs:
                run.font.name = "Segoe UI"
                run.font.size = Pt(9.5)
                run.font.bold = True
                run.font.color.rgb = RGBColor(255, 255, 255)

        # Data Rows
        for r_idx, row_data in enumerate(data):
            row = table.add_row()
            bg_col = "FFFFFF" if r_idx % 2 == 0 else "F9FAFB"
            for c_idx, val in enumerate(row_data):
                cell = row.cells[c_idx]
                cell.text = str(val)
                set_cell_background(cell, bg_col)
                set_cell_margins(cell, top=100, bottom=100, left=140, right=140)
                set_cell_borders(cell, 
                                 top={"val": "single", "sz": "4", "color": "E5E7EB"},
                                 bottom={"val": "single", "sz": "4", "color": "E5E7EB"},
                                 left={"val": "single", "sz": "4", "color": "E5E7EB"},
                                 right={"val": "single", "sz": "4", "color": "E5E7EB"})
                p = cell.paragraphs[0]
                p.paragraph_format.space_after = Pt(0)
                p.paragraph_format.line_spacing = 1.15
                for run in p.runs:
                    run.font.name = "Segoe UI"
                    run.font.size = Pt(9.5)
                    run.font.color.rgb = COLOR_TEXT

        if col_widths:
            for row in table.rows:
                for idx, width in enumerate(col_widths):
                    row.cells[idx].width = Inches(width)

        p_after = doc.add_paragraph()
        p_after.paragraph_format.space_after = Pt(4)

    # ==================== NỘI DUNG TÀI LIỆU ====================

    # 1. TRANG TIÊU ĐỀ
    add_title("TÀI LIỆU HƯỚNG DẪN CÀI ĐẶT & CHẠY ỨNG DỤNG", "Hệ Thống Học Từ Vựng Tiếng Trung HSK 1 - HSK 6 (Dự án HanziGo - PRJ301)")

    # Thông tin dự án dạng bảng tổng quan
    info_table = doc.add_table(rows=1, cols=2)
    info_table.alignment = WD_TABLE_ALIGNMENT.CENTER
    info_headers = ["Thông tin dự án", "Chi tiết cấu hình"]
    info_data = [
        ["Tên ứng dụng", "HanziGo (HonZi Web Application)"],
        ["Môn học & Chuyên ngành", "PRJ301 - Java Web Application (Lập trình Java Web)"],
        ["Kiến trúc hệ thống", "Mô hình MVC (Model - View - Controller) & DAO Pattern"],
        ["Công nghệ Back-End", "Java Servlet (Jakarta EE 10 / Servlet 6.0), JDBC"],
        ["Công nghệ Front-End", "JSP, JSTL 2.0, HTML5, CSS3, JavaScript ES6"],
        ["Hệ quản trị CSDL", "Microsoft SQL Server 2014 / 2016 / 2019 / 2022 (SSMS)"],
        ["Web Server khuyến nghị", "Apache Tomcat 10.1.x (Hỗ trợ Jakarta EE 10)"],
        ["IDE khuyến nghị", "Apache NetBeans 17 / 18 / 19 / 20 / 21 hoặc Eclipse / IntelliJ"],
        ["Phiên bản JDK yêu cầu", "Java Development Kit (JDK) 17 trở lên"]
    ]
    format_table_headers_and_rows(info_table, info_headers, info_data, col_widths=[2.3, 4.2])

    # 2. TỔNG QUAN TÍNH NĂNG HỆ THỐNG
    add_h1("1. TỔNG QUAN HỆ THỐNG VÀ CÁC TÍNH NĂNG CHÍNH")
    doc.add_paragraph(
        "HanziGo là nền tảng học từ vựng tiếng Trung toàn diện từ HSK 1 đến HSK 6, "
        "kết hợp các phương pháp ghi nhớ hiện đại như Flashcard lật thẻ 3D, Spaced Repetition (Lặp lại ngắt quãng), "
        "hệ thống kiểm tra trắc nghiệm Quiz tính điểm, cùng bảng điều khiển tiến độ trực quan."
    )

    add_h2("1.1. Các tính năng dành cho Học viên (User)")
    features_user = [
        "Đăng ký, Đăng nhập và Quên mật khẩu: Xác thực tài khoản an toàn với mã hóa mật khẩu SHA-256; Luồng lấy lại mật khẩu thông minh gửi mã OTP 6 số qua Email và đồng thời in trực tiếp trên Console máy chủ.",
        "Tra cứu kho từ vựng HSK 1 - HSK 6: Tìm kiếm theo chữ Hán, Pinyin phiên âm, nghĩa tiếng Việt, phân loại theo cấp độ HSK và chủ đề sinh hoạt.",
        "Luyện tập Flashcard tương tác: Lật thẻ chữ Hán xem phiên âm & câu ví dụ, phát âm giọng chuẩn (Web Speech API), đánh giá trạng thái nhớ (Chưa nhớ / Đang học / Đã thuộc).",
        "Làm bài kiểm tra trắc nghiệm (Quiz): Tùy chọn cấp độ HSK, đồng hồ đếm ngược thời gian, chấm điểm tự động tức thì, xem lại đáp án chi tiết và lưu lịch sử kết quả.",
        "Thống kê tiến độ học tập: Biểu đồ trực quan tỷ lệ từ vựng đã nắm vững, tỷ lệ chính xác Quiz, gợi ý từ cần ôn tập."
    ]
    for feat in features_user:
        p = doc.add_paragraph(style='List Bullet')
        p.paragraph_format.space_after = Pt(3)
        parts = feat.split(":", 1)
        r1 = p.add_run(parts[0] + ":")
        r1.bold = True
        r1.font.color.rgb = COLOR_SECONDARY
        r2 = p.add_run(parts[1])

    add_h2("1.2. Các tính năng dành cho Quản trị viên (Admin)")
    features_admin = [
        "Quản lý kho từ vựng: Thêm mới, chỉnh sửa, xóa từ vựng kèm chữ Hán, Pinyin, nghĩa tiếng Việt, cấp độ HSK, chủ đề và câu ví dụ minh họa.",
        "Import dữ liệu hàng loạt (Batch Import): Nhập nhanh hàng chục/hàng trăm từ vựng mới cùng lúc qua cấu trúc định dạng Excel/CSV tiện lợi.",
        "Quản lý người dùng: Xem danh sách thành viên, cập nhật thông tin, thay đổi phân quyền (ADMIN / USER), xóa tài khoản vi phạm.",
        "Báo cáo tổng quan hệ thống: Thống kê số lượng từ vựng theo từng HSK, số lượng người dùng đang hoạt động và số lượt bài thi đã hoàn thành."
    ]
    for feat in features_admin:
        p = doc.add_paragraph(style='List Bullet')
        p.paragraph_format.space_after = Pt(3)
        parts = feat.split(":", 1)
        r1 = p.add_run(parts[0] + ":")
        r1.bold = True
        r1.font.color.rgb = COLOR_PRIMARY
        r2 = p.add_run(parts[1])

    # 3. YÊU CẦU MÔI TRƯỜNG CÀI ĐẶT
    add_h1("2. YÊU CẦU MÔI TRƯỜNG VÀ CÔNG CỤ CẦN THIẾT")
    doc.add_paragraph("Để chạy ứng dụng HanziGo một cách mượt mà và không phát sinh lỗi phiên bản, máy tính của bạn cần được cài đặt các phần mềm sau:")

    env_table = doc.add_table(rows=1, cols=3)
    env_headers = ["Phần mềm / Công cụ", "Phiên bản yêu cầu", "Mục đích sử dụng"]
    env_data = [
        ["Java Development Kit (JDK)", "JDK 17 (hoặc 21)", "Biên dịch và thực thi mã nguồn Java"],
        ["Apache NetBeans IDE", "NetBeans 17, 18, 19, 20 hoặc 21", "Môi trường lập trình (IDE) quản lý dự án"],
        ["Apache Tomcat", "Tomcat 10.1.x (Jakarta EE 10)", "Web Server chạy ứng dụng Servlet/JSP"],
        ["Microsoft SQL Server", "SQL Server 2014 / 2016 / 2019 / 2022", "Lưu trữ dữ liệu ứng dụng (HanziGoDB)"],
        ["SQL Server Management Studio", "SSMS 18, 19 hoặc 20", "Giao diện quản trị và thực thi script SQL"],
        ["Trình duyệt Web", "Google Chrome, MS Edge, Firefox", "Giao diện trải nghiệm người dùng"]
    ]
    format_table_headers_and_rows(env_table, env_headers, env_data, col_widths=[2.0, 1.8, 2.7])

    add_callout(
        "LƯU Ý QUAN TRỌNG VỀ PHIÊN BẢN TOMCAT & JAKARTA EE",
        "Dự án sử dụng chuẩn Jakarta EE 10 (Servlet 6.0, JSTL 2.0). Vì vậy BẮT BUỘC sử dụng Apache Tomcat 10.1.x trở lên. Nếu bạn dùng Tomcat 9 trở xuống (chuẩn javax.servlet cũ) sẽ gặp lỗi không nhận diện servlet hoặc lỗi biên dịch JSP.",
        "warning"
    )

    # 4. HƯỚNG DẪN TỪNG BƯỚC CÀI ĐẶT VÀ CHẠY DỰ ÁN
    add_h1("3. HƯỚNG DẪN CHI TIẾT TỪNG BƯỚC CÀI ĐẶT VÀ CHẠY ỨNG DỤNG")

    # BƯỚC 1
    add_h2("Bước 1: Khởi tạo Cơ sở dữ liệu trong SQL Server")
    doc.add_paragraph(
        "Toàn bộ cấu trúc bảng, khóa ngoại, tài khoản Admin khởi tạo và kho từ vựng đầy đủ từ HSK 1 đến HSK 6 "
        "đã được đóng gói sẵn trong file schema.sql tại thư mục database của dự án."
    )
    
    steps_s1 = [
        "Mở công cụ SQL Server Management Studio (SSMS) trên máy tính.",
        "Đăng nhập vào SQL Server Instance (thường là Server Name: localhost hoặc .\\SQLEXPRESS với Authentication: SQL Server Authentication hoặc Windows Authentication).",
        "Trong SSMS, chọn File -> Open -> File... (hoặc nhấn Ctrl + O) và trỏ tới file: database/schema.sql trong thư mục dự án.",
        "Nhấn phím F5 hoặc nút Execute trên thanh công cụ để thực thi toàn bộ script.",
        "Kiểm tra thông báo thành công ở cửa sổ Messages: Database HanziGoDB cùng 4 bảng (Users, Words, UserProgress, QuizResults) đã được tạo đầy đủ."
    ]
    for s in steps_s1:
        p = doc.add_paragraph(style='List Bullet')
        p.paragraph_format.space_after = Pt(2)
        p.add_run(s)

    # BƯỚC 2
    add_h2("Bước 2: Kiểm tra cấu hình kết nối CSDL (DBConnection.java)")
    doc.add_paragraph(
        "Mở file DBConnection.java theo đường dẫn: src/java/util/DBConnection.java để kiểm tra thông tin tài khoản SQL Server của máy bạn:"
    )
    add_code_block(
        "// Vị trí: src/java/util/DBConnection.java\n"
        "private static final String URL = \"jdbc:sqlserver://localhost:1433;databaseName=HanziGoDB;encrypt=true;trustServerCertificate=true\";\n"
        "private static final String USER = \"sa\";\n"
        "private static final String PASS = \"sa\"; // <-- Thay đổi mật khẩu tài khoản sa của máy bạn nếu khác"
    )
    add_callout(
        "MẸO CẤU HÌNH TÀI KHOẢN SA",
        "Nếu mật khẩu SQL Server trên máy của bạn khác 'sa', hãy sửa lại chuỗi USER và PASS trong file DBConnection.java cho khớp. Đảm bảo cổng mặc định của SQL Server là 1433 đang được bật (TCP/IP Enabled trong SQL Server Configuration Manager).",
        "info"
    )

    # BƯỚC 3
    add_h2("Bước 3: Mở Dự án trong NetBeans IDE & Cấu hình Server")
    steps_s3 = [
        "Khởi động Apache NetBeans IDE (phiên bản 17 trở lên).",
        "Trên thanh menu, chọn File -> Open Project... (hoặc Ctrl + Shift + O).",
        "Duyệt đến thư mục chứa mã nguồn HonZi và bấm nút Open Project.",
        "Kiểm tra mục Libraries của dự án: Toàn bộ các file .jar cần thiết (mssql-jdbc-13.2.0.jre11.jar, jakarta.servlet.jsp.jstl-2.0.0.jar, jakarta.mail-2.0.3.jar, angus-activation-2.0.2.jar, ...) đã được liên kết tự động trong thư mục web/WEB-INF/lib.",
        "Thiết lập Server cho dự án: Nhấp chuột phải vào tên Project HonZi -> chọn Properties -> Chọn tab Run -> Ở mục Server, chọn Apache Tomcat 10.1 (Nếu chưa có, vào Tools -> Servers -> Add Server để thêm thư mục Apache Tomcat 10.1 của bạn)."
    ]
    for s in steps_s3:
        p = doc.add_paragraph(style='List Bullet')
        p.paragraph_format.space_after = Pt(3)
        p.add_run(s)

    # BƯỚC 4
    add_h2("Bước 4: Build và Chạy ứng dụng (Clean and Build & Run)")
    steps_s4 = [
        "Nhấp chuột phải vào tên dự án HonZi trong cửa sổ Projects bên trái -> Chọn Clean and Build. Đợi console hiển thị thông báo BUILD SUCCESSFUL.",
        "Nhấp chuột phải vào dự án HonZi -> Chọn Run (hoặc nhấn phím tắt F6).",
        "NetBeans sẽ tự động kích hoạt máy chủ Apache Tomcat, deploy gói ứng dụng HonZi.war và mở trình duyệt mặc định.",
        "Nếu trình duyệt không tự mở, bạn có thể chủ động truy cập theo đường dẫn chính thức sau:"
    ]
    for s in steps_s4:
        p = doc.add_paragraph(style='List Bullet')
        p.paragraph_format.space_after = Pt(2)
        p.add_run(s)

    add_code_block("👉 URL trang chủ: http://localhost:8080/HonZi/")

    # 5. TÀI KHOẢN MẪU VÀ KỊCH BẢN KIỂM THỬ
    add_h1("4. DANH SÁCH TÀI KHOẢN MẪU & KỊCH BẢN TRẢI NGHIỆM")
    
    doc.add_paragraph("Hệ thống đã được thiết lập sẵn tài khoản Quản trị viên và cho phép đăng ký không giới hạn tài khoản học viên mới:")

    acc_table = doc.add_table(rows=1, cols=4)
    acc_headers = ["Loại tài khoản", "Tên đăng nhập (Username)", "Mật khẩu (Password)", "Quyền hạn (Role)"]
    acc_data = [
        ["Quản trị viên (Admin)", "admin", "admin", "ADMIN (Toàn quyền quản trị)"],
        ["Học viên mẫu (User)", "Tự đăng ký tại /register", "Tùy ý người dùng tạo", "USER (Học viên tiêu chuẩn)"]
    ]
    format_table_headers_and_rows(acc_table, acc_headers, acc_data, col_widths=[1.8, 1.8, 1.5, 1.4])

    add_h2("4.1. Kịch bản 1: Trải nghiệm với Quyền Học viên (User Flow)")
    doc.add_paragraph("1. Truy cập Trang chủ: Quan sát giao diện giới thiệu, biểu đồ tính năng và các cấp độ HSK 1 -> 6.")
    doc.add_paragraph("2. Đăng ký tài khoản: Chọn Đăng ký, nhập Username, Email, Mật khẩu -> Đăng nhập vào hệ thống.")
    doc.add_paragraph("3. Học Flashcard: Vào menu Flashcard -> Chọn cấp độ HSK (ví dụ HSK 1 hoặc HSK 2) -> Click vào thẻ để lật xem phiên âm & câu ví dụ -> Click icon Loa 🔊 để nghe phát âm -> Đánh giá mức độ nhớ.")
    doc.add_paragraph("4. Làm bài Quiz: Vào menu Kiểm tra Quiz -> Chọn cấp độ thi -> Làm bài trắc nghiệm trắc nghiệm 4 đáp án với bộ đếm giờ -> Bấm Nộp bài xem điểm số tức thì và giải thích.")
    doc.add_paragraph("5. Theo dõi Tiến độ: Vào menu Tiến độ học -> Xem tỷ lệ từ vựng đã nắm vững, điểm số trung bình và lịch sử bài thi.")

    add_h2("4.2. Kịch bản 2: Trải nghiệm với Quyền Quản trị viên (Admin Flow)")
    doc.add_paragraph("1. Đăng nhập tài khoản Admin: Sử dụng username: admin / mật khẩu: admin.")
    doc.add_paragraph("2. Quản lý Từ vựng: Vào menu Quản lý từ vựng -> Thử Thêm từ mới, Sửa phiên âm/nghĩa/câu ví dụ, hoặc Xóa từ vựng.")
    doc.add_paragraph("3. Nhập dữ liệu hàng loạt: Vào mục Import từ vựng -> Nhập nhiều từ cùng lúc theo định dạng mẫu và kiểm tra kết quả nạp tự động vào CSDL.")
    doc.add_paragraph("4. Quản lý Người dùng: Vào menu Quản trị người dùng -> Xem danh sách tài khoản, chỉnh sửa thông tin, phân quyền ADMIN/USER hoặc xóa tài khoản.")

    add_h2("4.3. Kịch bản 3: Kiểm thử Tính năng Quên mật khẩu & OTP")
    doc.add_paragraph("1. Tại màn hình Đăng nhập, bấm Quên mật khẩu?.")
    doc.add_paragraph("2. Nhập Email hoặc Username đã đăng ký.")
    doc.add_paragraph("3. Hệ thống sẽ sinh mã OTP 6 số. Mã OTP sẽ được gửi về email (nếu có cấu hình mạng/SMTP) và đồng thời IN RÕ TRÊN CONSOLE của NetBeans Output để bạn có thể kiểm thử ngay lập tức mà không sợ bị trễ thư.")
    doc.add_paragraph("4. Nhập mã OTP -> Tiến hành Đặt lại mật khẩu mới -> Đăng nhập lại thành công với mật khẩu mới.")

    # 6. HƯỚNG DẪN XỬ LÝ LỖI THƯỜNG GẶP (FAQ & TROUBLESHOOTING)
    add_h1("5. HƯỚNG DẪN XỬ LÝ CÁC LỖI THƯỜNG GẶP (TROUBLESHOOTING)")

    faq_list = [
        {
            "err": "Lỗi 1: Không kết nối được Database (Cannot open database 'HanziGoDB' hoặc Login failed for user 'sa')",
            "cause": "Chưa chạy script schema.sql, sai mật khẩu sa trong DBConnection.java, hoặc dịch vụ SQL Server chưa bật cổng 1433.",
            "fix": "1. Mở SSMS và chắc chắn đã chạy F5 file database/schema.sql.\n2. Mở file src/java/util/DBConnection.java, kiểm tra lại biến USER và PASS khớp với mật khẩu sa máy tính của bạn.\n3. Mở SQL Server Configuration Manager -> SQL Server Network Configuration -> Protocols for MSSQLSERVER -> Đảm bảo TCP/IP là Enabled và cổng TCP Port là 1433."
        },
        {
            "err": "Lỗi 2: Trình duyệt báo lỗi HTTP Status 404 - Not Found",
            "cause": "Đường dẫn Context Path chưa chính xác hoặc Web App chưa được deploy đúng lên Tomcat.",
            "fix": "1. Kiểm tra chính xác URL: http://localhost:8080/HonZi/ (chú ý chữ hoa/thường trong HonZi).\n2. Trong NetBeans, nhấp chuột phải vào dự án HonZi -> chọn Clean and Build -> sau đó chọn Run lại."
        },
        {
            "err": "Lỗi 3: Lỗi biên dịch JSP / Lỗi liên quan đến javax.* hoặc jakarta.* (HTTP 500)",
            "cause": "Đang chạy ứng dụng trên Tomcat phiên bản cũ (Tomcat 8 hoặc 9) không hỗ trợ chuẩn Jakarta EE 10.",
            "fix": "Dự án yêu cầu chuẩn Jakarta EE 10 (Jakarta Servlet 6.0). Bạn cần cài đặt và add máy chủ Apache Tomcat 10.1.x vào NetBeans (Tools -> Servers -> Add Server -> Tomcat 10.1.x) và gán làm Server chạy dự án."
        },
        {
            "err": "Lỗi 4: Cổng 8080 của Tomcat bị xung đột (Port 8080 already in use)",
            "cause": "Có phần mềm khác (như Oracle, IIS, Spring Boot, hoặc một tiến trình Tomcat chạy ngầm) đang chiếm dụng cổng 8080.",
            "fix": "Cách 1: Tắt tiến trình đang chiếm cổng 8080 qua Task Manager hoặc lệnh netstat -ano.\nCách 2: Đổi cổng của Tomcat sang 8081 hoặc 8088 trong file cấu hình conf/server.xml của Tomcat (thay đổi dòng <Connector port=\"8080\" protocol=\"HTTP/1.1\".../> thành 8081)."
        },
        {
            "err": "Lỗi 5: Tiếng Trung hoặc Tiếng Việt bị lỗi font hiển thị dạng dấu ? hoặc ký tự lạ",
            "cause": "Mã hóa ký tự chưa đặt UTF-8.",
            "fix": "Toàn bộ file JSP và Servlet của dự án đã được thiết lập sẵn UTF-8 (request.setCharacterEncoding(\"UTF-8\") và response.setContentType(\"text/html;charset=UTF-8\")). Đảm bảo cơ sở dữ liệu SQL Server sử dụng kiểu dữ liệu NVARCHAR (đã có sẵn trong schema.sql)."
        }
    ]

    for item in faq_list:
        add_h2(item["err"])
        p_c = doc.add_paragraph()
        r_c_t = p_c.add_run("Nguyên nhân: ")
        r_c_t.bold = True
        r_c_t.font.color.rgb = COLOR_ACCENT
        p_c.add_run(item["cause"])

        p_f = doc.add_paragraph()
        r_f_t = p_f.add_run("Cách khắc phục: \n")
        r_f_t.bold = True
        r_f_t.font.color.rgb = RGBColor(5, 150, 105) # Green
        p_f.add_run(item["fix"])

    # 7. TỔNG KẾT & CẤU TRÚC THƯ MỤC DỰ ÁN
    add_h1("6. SƠ ĐỒ CẤU TRÚC MÃ NGUỒN (MVC ARCHITECTURE)")
    doc.add_paragraph("Mã nguồn dự án được tổ chức chặt chẽ theo mô hình chuẩn MVC & DAO Pattern:")

    code_tree = (
        "HonZi/\n"
        "├── database/\n"
        "│   └── schema.sql                  # Script tạo Database HanziGoDB & nạp toàn bộ từ vựng HSK 1-6\n"
        "├── src/java/\n"
        "│   ├── controller/                 # Các Servlet xử lý Routing và nghiệp vụ điều hướng\n"
        "│   │   ├── AdminUserServlet.java   # Quản lý tài khoản người dùng và phân quyền\n"
        "│   │   ├── AuthServlet.java        # Đăng nhập, đăng ký, đăng xuất\n"
        "│   │   ├── FlashcardServlet.java   # Luyện tập thẻ từ vựng & cập nhật trạng thái nhớ\n"
        "│   │   ├── ForgotPasswordServlet.java # Quên mật khẩu, gửi & xác thực OTP\n"
        "│   │   ├── ProgressServlet.java    # Báo cáo tiến độ & thống kê học tập cá nhân\n"
        "│   │   ├── QuizServlet.java        # Bài kiểm tra trắc nghiệm & lưu kết quả\n"
        "│   │   └── WordServlet.java        # Quản lý kho từ vựng (CRUD & Import batch)\n"
        "│   ├── dao/                        # Data Access Object thao tác trực tiếp với SQL Server\n"
        "│   │   ├── ProgressDAO.java        # Xử lý truy vấn bảng UserProgress\n"
        "│   │   ├── QuizDAO.java            # Xử lý truy vấn bảng QuizResults\n"
        "│   │   ├── UserDAO.java            # Xử lý truy vấn bảng Users & mã hóa\n"
        "│   │   └── WordDAO.java            # Xử lý truy vấn bảng Words\n"
        "│   ├── model/                      # Các Entity và Data Transfer Object (DTO)\n"
        "│   └── util/                       # Các lớp tiện ích hỗ trợ\n"
        "│       ├── DBConnection.java       # Kết nối JDBC đến SQL Server\n"
        "│       ├── EmailUtil.java          # Tiện ích gửi mã OTP qua Gmail SMTP & Console\n"
        "│       ├── ExcelUtil.java          # Tiện ích Import dữ liệu từ vựng\n"
        "│       └── PasswordUtil.java       # Tiện ích mã hóa bảo mật SHA-256\n"
        "└── web/\n"
        "    ├── common/                     # Giao diện dùng chung (header.jsp, navbar.jsp, footer.jsp)\n"
        "    ├── WEB-INF/\n"
        "    │   ├── lib/                    # Chứa đầy đủ các thư viện .JAR cần thiết\n"
        "    │   └── web.xml                 # Cấu hình Web Descriptor & Session timeout\n"
        "    └── *.jsp                       # Các trang giao diện hiển thị (index, flashcard, quiz, ...)"
    )
    add_code_block(code_tree)

    # Save to disk
    output_path = r"c:\Users\huyza\OneDrive\Máy tính\PRJ ASGN\HonZi\HUONG_DAN_CHAY_CHUONG_TRINH_HANZIGO.docx"
    doc.save(output_path)
    print(f"Document created successfully at: {output_path}")

if __name__ == "__main__":
    create_document()

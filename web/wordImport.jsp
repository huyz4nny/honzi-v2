<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>

<jsp:include page="/common/header.jsp" />
<jsp:include page="/common/navbar.jsp" />

<div class="main-content py-10" style="background: var(--bg-surface-subtle); min-height: 85vh;">
    <div class="container container-md" style="max-width: 920px;">
        
        <!-- Header & Breadcrumb -->
        <div class="d-flex flex-wrap align-items-center justify-content-between gap-3 mb-6">
            <div>
                <a href="${pageContext.request.contextPath}/words" class="btn btn-ghost btn-sm mb-2" style="padding-left: 0; color: var(--text-muted);">
                    <i class="fa-solid fa-arrow-left me-1"></i> Quay lại kho từ vựng
                </a>
                <h1 class="text-ink fw-extrabold tracking-tight d-flex align-items-center gap-2" style="font-size: 1.75rem;">
                    <span style="display: inline-flex; align-items: center; justify-content: center; width: 40px; height: 40px; border-radius: 10px; background: rgba(46, 117, 89, 0.12); color: #2e7559;">
                        <i class="fa-solid fa-file-excel" style="font-size: 1.25rem;"></i>
                    </span>
                    Nhập nhanh từ vựng từ Excel
                </h1>
                <p class="text-muted mt-1" style="font-size: 0.875rem;">
                    Tải lên file bảng tính để thêm mới hàng loạt hoặc cập nhật kho từ vựng chỉ trong 1 thao tác.
                </p>
            </div>
            <div>
                <a href="${pageContext.request.contextPath}/words/add" class="btn btn-outline btn-sm shadow-sm" style="background: #ffffff;">
                    <i class="fa-solid fa-plus me-1"></i> Thêm từ đơn lẻ
                </a>
            </div>
        </div>

        <!-- BẢNG BÁO CÁO KẾT QUẢ IMPORT -->
        <c:if test="${not empty importResult}">
            <div class="card-plain shadow-card mb-8" style="background: #ffffff; border-radius: 16px; border: 1px solid rgba(46, 117, 89, 0.25); box-shadow: 0 10px 25px -5px rgba(0, 0, 0, 0.05);">
                <div class="d-flex flex-wrap align-items-center justify-content-between gap-2 pb-4 mb-4" style="border-bottom: 1px dashed rgba(0,0,0,0.1);">
                    <div class="d-flex align-items-center gap-2">
                        <span style="width: 32px; height: 32px; border-radius: 50%; background: rgba(46, 117, 89, 0.12); color: #2e7559; display: flex; align-items: center; justify-content: center;">
                            <i class="fa-solid fa-check" style="font-size: 0.9rem;"></i>
                        </span>
                        <div>
                            <h3 class="fw-bold text-ink mb-0" style="font-size: 1.1rem;">
                                Nạp dữ liệu hoàn tất!
                            </h3>
                            <span class="text-muted" style="font-size: 0.8rem;">
                                Nguồn: <b>${importSource}</b>
                            </span>
                        </div>
                    </div>
                    <a href="${pageContext.request.contextPath}/words" class="btn btn-primary btn-sm shadow-sm">
                        <i class="fa-solid fa-list me-1"></i> Xem danh sách từ vựng
                    </a>
                </div>

                <!-- 4 Cột KPI Thống Kê Ngang Đẹp Mắt -->
                <div style="display: grid; grid-template-columns: repeat(4, 1fr); gap: 12px;" class="mb-4">
                    <div style="background: #f8fafc; padding: 1rem 0.75rem; border-radius: 12px; border: 1px solid #e2e8f0; text-align: center;">
                        <span class="text-muted fw-semibold d-block" style="font-size: 0.75rem; text-transform: uppercase; letter-spacing: 0.5px;">Tổng số dòng</span>
                        <span class="text-ink fw-extrabold d-block mt-1" style="font-size: 1.6rem; line-height: 1;">${importResult.totalRows}</span>
                    </div>

                    <div style="background: rgba(46, 117, 89, 0.06); padding: 1rem 0.75rem; border-radius: 12px; border: 1px solid rgba(46, 117, 89, 0.2); text-align: center;">
                        <span class="fw-semibold d-block" style="font-size: 0.75rem; text-transform: uppercase; letter-spacing: 0.5px; color: #2e7559;">✓ Thêm mới</span>
                        <span class="fw-extrabold d-block mt-1" style="font-size: 1.6rem; line-height: 1; color: #2e7559;">${importResult.insertedCount}</span>
                    </div>

                    <div style="background: rgba(37, 99, 246, 0.06); padding: 1rem 0.75rem; border-radius: 12px; border: 1px solid rgba(37, 99, 246, 0.2); text-align: center;">
                        <span class="fw-semibold d-block" style="font-size: 0.75rem; text-transform: uppercase; letter-spacing: 0.5px; color: #2563eb;">🔄 Cập nhật</span>
                        <span class="fw-extrabold d-block mt-1" style="font-size: 1.6rem; line-height: 1; color: #2563eb;">${importResult.updatedCount}</span>
                    </div>

                    <div style="background: rgba(217, 119, 6, 0.06); padding: 1rem 0.75rem; border-radius: 12px; border: 1px solid rgba(217, 119, 6, 0.2); text-align: center;">
                        <span class="fw-semibold d-block" style="font-size: 0.75rem; text-transform: uppercase; letter-spacing: 0.5px; color: #d97706;">⏭️ Bỏ qua</span>
                        <span class="fw-extrabold d-block mt-1" style="font-size: 1.6rem; line-height: 1; color: #d97706;">${importResult.skippedCount}</span>
                    </div>
                </div>

                <!-- Danh sách từ đã cập nhật -->
                <c:if test="${not empty importResult.updatedWords}">
                    <div style="background: #f8fafc; padding: 1rem; border-radius: 10px; border: 1px solid #e2e8f0;" class="mb-3">
                        <span class="text-muted fw-bold d-block mb-2" style="font-size: 0.8rem;">
                            <i class="fa-solid fa-arrows-rotate me-1 text-primary"></i> Các từ vựng đã được cập nhật dữ liệu mới:
                        </span>
                        <div style="display: flex; flex-wrap: wrap; gap: 6px;">
                            <c:forEach var="uw" items="${importResult.updatedWords}">
                                <span style="display: inline-flex; align-items: center; background: #ffffff; padding: 3px 10px; border-radius: 9999px; border: 1px solid #cbd5e1; font-size: 0.85rem; font-weight: bold; color: var(--primary); font-family: 'Microsoft YaHei', sans-serif; box-shadow: 0 1px 2px rgba(0,0,0,0.04);">
                                    ${uw}
                                </span>
                            </c:forEach>
                        </div>
                    </div>
                </c:if>

                <!-- Danh sách từ bỏ qua -->
                <c:if test="${not empty importResult.skippedWords}">
                    <div style="background: #f8fafc; padding: 1rem; border-radius: 10px; border: 1px solid #e2e8f0;">
                        <span class="text-muted fw-bold d-block mb-2" style="font-size: 0.8rem;">
                            <i class="fa-solid fa-forward-step me-1" style="color: #d97706;"></i> Các từ đã tồn tại (giữ nguyên):
                        </span>
                        <div style="display: flex; flex-wrap: wrap; gap: 6px;">
                            <c:forEach var="sw" items="${importResult.skippedWords}">
                                <span style="display: inline-flex; align-items: center; background: #ffffff; padding: 3px 10px; border-radius: 9999px; border: 1px solid #cbd5e1; font-size: 0.85rem; color: #64748b; font-family: 'Microsoft YaHei', sans-serif;">
                                    ${sw}
                                </span>
                            </c:forEach>
                        </div>
                    </div>
                </c:if>
            </div>
        </c:if>

        <!-- Error Notification -->
        <c:if test="${not empty requestScope.errorMessage}">
            <div class="alert-box alert-error mb-6" style="border-radius: 12px;">
                <i class="fa-solid fa-triangle-exclamation"></i>
                <div>${requestScope.errorMessage}</div>
            </div>
        </c:if>

        <!-- BƯỚC 1: TẢI FILE MẪU EXCEL -->
        <div class="card-plain shadow-card mb-6" style="background: #ffffff; border-radius: 16px;">
            <div class="d-flex align-items-center justify-content-between mb-3">
                <h2 class="text-ink fw-bold mb-0" style="font-size: 1.1rem;">
                    <span style="display: inline-block; width: 24px; height: 24px; border-radius: 50%; background: var(--primary); color: #fff; text-align: center; line-height: 24px; font-size: 0.8rem; margin-right: 6px;">1</span>
                    Tải mẫu bảng tính Excel để nhập liệu
                </h2>
                <span class="badge" style="background: #f1f5f9; color: #475569; font-weight: 500;">Chuẩn 7 cột</span>
            </div>
            <p class="text-muted mb-4" style="font-size: 0.85rem;">
                Tải file Excel mẫu về máy để điền dữ liệu đúng định dạng, hoặc tải file mẫu có sẵn hơn 30 từ HSK 1 - 4 để nạp thử:
            </p>

            <div style="display: grid; grid-template-columns: repeat(auto-fit, minmax(280px, 1fr)); gap: 16px;">
                <!-- Card 1: Template trống -->
                <div style="background: var(--bg-surface-subtle); padding: 1.25rem; border-radius: 12px; border: 1px solid var(--border-color); display: flex; flex-direction: column; justify-content: space-between;">
                    <div class="d-flex align-items-center gap-3 mb-3">
                        <div style="width: 44px; height: 44px; border-radius: 10px; background: rgba(46, 117, 89, 0.1); display: flex; align-items: center; justify-content: center; flex-shrink: 0;">
                            <i class="fa-solid fa-file-excel text-success" style="font-size: 1.4rem; color: #2e7559;"></i>
                        </div>
                        <div>
                            <h4 class="text-ink fw-bold mb-0" style="font-size: 0.95rem;">Template Mẫu Trống</h4>
                            <span class="text-muted" style="font-size: 0.75rem;">Có sẵn tiêu đề cột chuẩn</span>
                        </div>
                    </div>
                    <div class="d-flex gap-2 mt-2">
                        <a href="${pageContext.request.contextPath}/assets/templates/HanziGo_Vocabulary_Template.xlsx" 
                           class="btn btn-outline btn-sm w-full shadow-sm" style="background: #ffffff;" download>
                            <i class="fa-solid fa-download me-1 text-primary"></i> Tải .XLSX
                        </a>
                        <a href="${pageContext.request.contextPath}/assets/templates/HanziGo_Vocabulary_Template.csv" 
                           class="btn btn-ghost btn-sm" title="Tải bản CSV" download>
                            .CSV
                        </a>
                    </div>
                </div>

                <!-- Card 2: Sample có sẵn 30+ từ -->
                <div style="background: rgba(235, 78, 43, 0.04); padding: 1.25rem; border-radius: 12px; border: 1px solid rgba(235, 78, 43, 0.2); display: flex; flex-direction: column; justify-content: space-between;">
                    <div class="d-flex align-items-center gap-3 mb-3">
                        <div style="width: 44px; height: 44px; border-radius: 10px; background: rgba(235, 78, 43, 0.1); display: flex; align-items: center; justify-content: center; flex-shrink: 0;">
                            <i class="fa-solid fa-file-lines text-primary" style="font-size: 1.4rem;"></i>
                        </div>
                        <div>
                            <h4 class="text-ink fw-bold mb-0" style="font-size: 0.95rem;">Bộ 30+ Từ Vựng Mẫu (HSK 1-4)</h4>
                            <span class="text-muted" style="font-size: 0.75rem;">Đầy đủ Pinyin, Nghĩa & Ví dụ</span>
                        </div>
                    </div>
                    <div class="d-flex gap-2 mt-2">
                        <a href="${pageContext.request.contextPath}/assets/templates/HanziGo_Sample_Vocabulary_HSK.xlsx" 
                           class="btn btn-primary btn-sm w-full shadow-sm" download>
                            <i class="fa-solid fa-file-excel me-1"></i> Tải file .XLSX mẫu
                        </a>
                        <a href="${pageContext.request.contextPath}/assets/templates/HanziGo_Sample_Vocabulary_HSK.csv" 
                           class="btn btn-ghost btn-sm" title="Tải bản CSV" download>
                            .CSV
                        </a>
                    </div>
                </div>
            </div>
        </div>

        <!-- BƯỚC 2: FORM NẠP DỮ LIỆU -->
        <div class="card-plain shadow-card p-0 mb-8" style="background: #ffffff; border-radius: 16px; overflow: hidden;">
            <div class="p-4 border-bottom d-flex align-items-center justify-content-between">
                <h2 class="text-ink fw-bold mb-0" style="font-size: 1.1rem;">
                    <span style="display: inline-block; width: 24px; height: 24px; border-radius: 50%; background: var(--primary); color: #fff; text-align: center; line-height: 24px; font-size: 0.8rem; margin-right: 6px;">2</span>
                    Chọn phương thức nhập từ vựng
                </h2>
            </div>

            <!-- Segmented Pill Tabs -->
            <div class="p-3 border-bottom" style="background: var(--bg-surface-subtle);">
                <div style="display: inline-flex; background: #e2e8f0; padding: 4px; border-radius: 10px; width: 100%;">
                    <button type="button" 
                            id="tabUploadBtn"
                            onclick="switchImportTab('tabUpload', 'tabPaste', this)"
                            style="flex: 1; border: none; padding: 8px 16px; border-radius: 8px; font-weight: 700; font-size: 0.875rem; background: #ffffff; color: var(--primary); cursor: pointer; transition: all 0.2s ease; box-shadow: 0 1px 3px rgba(0,0,0,0.08);">
                        <i class="fa-solid fa-cloud-arrow-up me-2"></i>Tải tệp Excel (.xlsx / .csv)
                    </button>
                    <button type="button" 
                            id="tabPasteBtn"
                            onclick="switchImportTab('tabPaste', 'tabUpload', this)"
                            style="flex: 1; border: none; padding: 8px 16px; border-radius: 8px; font-weight: 700; font-size: 0.875rem; background: transparent; color: var(--text-muted); cursor: pointer; transition: all 0.2s ease;">
                        <i class="fa-solid fa-paste me-2"></i>Dán trực tiếp từ bảng tính
                    </button>
                </div>
            </div>

            <!-- TAB 1: UPLOAD FILE -->
            <div id="tabUpload" class="p-6">
                <form action="${pageContext.request.contextPath}/words/import" method="post" enctype="multipart/form-data" class="d-grid gap-5">
                    
                    <!-- Tuỳ chọn xử lý trùng lặp -->
                    <div style="background: var(--bg-surface-subtle); padding: 1.25rem; border-radius: 12px; border: 1px solid var(--border-color);">
                        <label class="form-label fw-bold text-ink mb-2 d-flex align-items-center gap-2">
                            <i class="fa-solid fa-arrows-rotate text-primary"></i> Quy tắc xử lý khi từ vựng đã có trong CSDL:
                        </label>
                        <div class="d-grid sm-grid-cols-2 gap-3 mt-2">
                            <label style="background: #ffffff; padding: 1rem; border-radius: 10px; border: 1.5px solid var(--primary); cursor: pointer; display: flex; gap: 10px; align-items: flex-start;">
                                <input type="radio" name="duplicateMode" value="update" checked style="accent-color: var(--primary); margin-top: 3px;">
                                <div>
                                    <b class="text-ink d-block" style="font-size: 0.9rem;">Cập nhật nội dung mới nhất</b>
                                    <span class="text-muted d-block mt-1" style="font-size: 0.78rem; line-height: 1.4;">
                                        Ghi đè Pinyin, Nghĩa, Ví dụ mới vào CSDL và giữ nguyên ID/tiến độ học của học viên.
                                    </span>
                                </div>
                            </label>

                            <label style="background: #ffffff; padding: 1rem; border-radius: 10px; border: 1.5px solid #cbd5e1; cursor: pointer; display: flex; gap: 10px; align-items: flex-start;">
                                <input type="radio" name="duplicateMode" value="skip" style="accent-color: var(--primary); margin-top: 3px;">
                                <div>
                                    <b class="text-ink d-block" style="font-size: 0.9rem;">Bỏ qua các từ đã tồn tại</b>
                                    <span class="text-muted d-block mt-1" style="font-size: 0.78rem; line-height: 1.4;">
                                        Chỉ thêm các từ vựng hoàn toàn mới, không chỉnh sửa dữ liệu cũ.
                                    </span>
                                </div>
                            </label>
                        </div>
                    </div>

                    <!-- Dropzone / File Picker -->
                    <div style="border: 2px dashed #cbd5e1; border-radius: 14px; padding: 2.5rem 1.5rem; text-align: center; background: #fafbfc; transition: all 0.2s ease;">
                        <div style="width: 56px; height: 56px; border-radius: 50%; background: rgba(46, 117, 89, 0.1); color: #2e7559; display: inline-flex; align-items: center; justify-content: center; margin-bottom: 1rem;">
                            <i class="fa-solid fa-file-excel" style="font-size: 1.75rem;"></i>
                        </div>
                        <h4 class="text-ink fw-bold mb-1" style="font-size: 1rem;">Chọn hoặc Kéo thả tệp Excel vào đây</h4>
                        <p class="text-muted mb-4" style="font-size: 0.8rem;">Hỗ trợ định dạng <b>.XLSX</b> (Microsoft Excel) hoặc <b>.CSV</b> (Tối đa 10MB)</p>
                        
                        <input type="file" 
                               name="file" 
                               id="excelFileInput"
                               class="form-control" 
                               accept=".xlsx, .csv, application/vnd.openxmlformats-officedocument.spreadsheetml.sheet, text/csv" 
                               required 
                               style="max-width: 360px; margin: 0 auto; padding: 0.6rem;" 
                               onchange="updateFileName(this)" />
                    </div>

                    <button type="submit" class="btn btn-primary btn-lg w-full shadow-lift">
                        <i class="fa-solid fa-cloud-arrow-up me-2"></i> Bắt đầu nạp từ vựng vào hệ thống
                    </button>
                </form>
            </div>

            <!-- TAB 2: DÁN TRỰC TIẾP -->
            <div id="tabPaste" class="p-6" style="display: none;">
                <form action="${pageContext.request.contextPath}/words/import" method="post" class="d-grid gap-5">
                    <!-- Tuỳ chọn xử lý trùng lặp -->
                    <div style="background: var(--bg-surface-subtle); padding: 1.25rem; border-radius: 12px; border: 1px solid var(--border-color);">
                        <label class="form-label fw-bold text-ink mb-2 d-flex align-items-center gap-2">
                            <i class="fa-solid fa-arrows-rotate text-primary"></i> Quy tắc xử lý khi từ vựng đã có trong CSDL:
                        </label>
                        <div class="d-grid sm-grid-cols-2 gap-3 mt-2">
                            <label style="background: #ffffff; padding: 1rem; border-radius: 10px; border: 1.5px solid var(--primary); cursor: pointer; display: flex; gap: 10px; align-items: flex-start;">
                                <input type="radio" name="duplicateMode" value="update" checked style="accent-color: var(--primary); margin-top: 3px;">
                                <div>
                                    <b class="text-ink d-block" style="font-size: 0.9rem;">Cập nhật nội dung mới nhất</b>
                                    <span class="text-muted d-block mt-1" style="font-size: 0.78rem;">Ghi đè nội dung mới nhất vào CSDL.</span>
                                </div>
                            </label>

                            <label style="background: #ffffff; padding: 1rem; border-radius: 10px; border: 1.5px solid #cbd5e1; cursor: pointer; display: flex; gap: 10px; align-items: flex-start;">
                                <input type="radio" name="duplicateMode" value="skip" style="accent-color: var(--primary); margin-top: 3px;">
                                <div>
                                    <b class="text-ink d-block" style="font-size: 0.9rem;">Bỏ qua các từ đã tồn tại</b>
                                    <span class="text-muted d-block mt-1" style="font-size: 0.78rem;">Chỉ thêm các từ hoàn toàn mới.</span>
                                </div>
                            </label>
                        </div>
                    </div>

                    <div class="form-group">
                        <label class="form-label fw-bold">Dán các dòng sao chép từ Excel hoặc Google Sheets</label>
                        <textarea name="pastedText" 
                                  class="form-control font-hanzi" 
                                  rows="7" 
                                  placeholder="Sao chép các dòng trong Excel rồi dán thẳng vào đây:
你好	nǐ hǎo	Xin chào	1	Chào hỏi	你好，很高兴认识你。	Xin chào, rất vui được làm quen với bạn.
谢谢	xièxie	Cảm ơn	1	Giao tiếp	谢谢你的帮助。	Cảm ơn sự giúp đỡ của bạn." 
                                  required></textarea>
                        <span class="text-muted mt-2 d-block" style="font-size: 0.8rem;">
                            Định dạng: <code>Hán tự [Tab] Pinyin [Tab] Nghĩa tiếng Việt [Tab] Cấp HSK [Tab] Chủ đề [Tab] Câu ví dụ [Tab] Dịch nghĩa</code>
                        </span>
                    </div>

                    <button type="submit" class="btn btn-primary btn-lg w-full shadow-lift">
                        <i class="fa-solid fa-paste me-2"></i> Xử lý và nạp dữ liệu đã dán
                    </button>
                </form>
            </div>
        </div>
    </div>
</div>

<script>
function switchImportTab(showId, hideId, activeBtn) {
    document.getElementById(showId).style.display = 'block';
    document.getElementById(hideId).style.display = 'none';

    var uploadBtn = document.getElementById('tabUploadBtn');
    var pasteBtn = document.getElementById('tabPasteBtn');

    uploadBtn.style.background = 'transparent';
    uploadBtn.style.color = 'var(--text-muted)';
    uploadBtn.style.boxShadow = 'none';

    pasteBtn.style.background = 'transparent';
    pasteBtn.style.color = 'var(--text-muted)';
    pasteBtn.style.boxShadow = 'none';

    activeBtn.style.background = '#ffffff';
    activeBtn.style.color = 'var(--primary)';
    activeBtn.style.boxShadow = '0 1px 3px rgba(0,0,0,0.08)';
}

function updateFileName(input) {
    if (input.files && input.files[0]) {
        console.log("Đã chọn file:", input.files[0].name);
    }
}
</script>

<jsp:include page="/common/footer.jsp" />

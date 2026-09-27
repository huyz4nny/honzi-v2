<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>

<jsp:include page="/common/header.jsp" />
<jsp:include page="/common/navbar.jsp" />

<div class="main-content py-10">
    <div class="container container-md">
        <div class="card-plain shadow-card" style="padding: 2rem;">
            <!-- Header -->
            <div class="d-flex align-items-center justify-content-between mb-6 pb-4" style="border-bottom: 1px solid var(--border);">
                <div>
                    <h1 class="text-ink fw-extrabold tracking-tight" style="font-size: 1.5rem;">
                        <c:choose>
                            <c:when test="${action eq 'edit'}">
                                Chỉnh sửa từ vựng #${word.wordId}
                            </c:when>
                            <c:otherwise>
                                Thêm từ vựng HSK mới
                            </c:otherwise>
                        </c:choose>
                    </h1>
                    <p class="text-muted mt-1" style="font-size: 0.875rem;">
                        Nhập đầy đủ thông tin chữ Hán, phiên âm và giải nghĩa tiếng Việt.
                    </p>
                </div>
                <a href="${pageContext.request.contextPath}/words" class="btn btn-outline btn-sm">
                    <i class="fa-solid fa-arrow-left me-1"></i> Quay lại
                </a>
            </div>

            <!-- Error Banner -->
            <c:if test="${not empty errorMessage}">
                <div class="alert-box alert-error mb-4">
                    <i class="fa-solid fa-triangle-exclamation"></i>
                    <div>${errorMessage}</div>
                </div>
            </c:if>

            <form action="${pageContext.request.contextPath}/words/${action eq 'edit' ? 'edit' : 'add'}" method="post">
                <c:if test="${action eq 'edit'}">
                    <input type="hidden" name="id" value="${word.wordId}" />
                </c:if>

                <div class="d-grid gap-4">
                    <!-- Row 1: Hanzi, Pinyin, HSK Level -->
                    <div class="d-grid sm-grid-cols-3 gap-3">
                        <div class="form-group">
                            <label class="form-label">Hán tự (Hanzi) <span class="text-danger">*</span></label>
                            <input type="text" 
                                   name="hanzi" 
                                   class="form-control font-hanzi fw-bold text-primary" 
                                   style="font-size: 1.25rem;" 
                                   placeholder="vd: 你好" 
                                   value="${word.hanzi}" 
                                   required />
                        </div>

                        <div class="form-group">
                            <label class="form-label">Phiên âm (Pinyin) <span class="text-danger">*</span></label>
                            <input type="text" 
                                   name="pinyin" 
                                   class="form-control fw-semibold" 
                                   placeholder="vd: nǐ hǎo" 
                                   value="${word.pinyin}" 
                                   required />
                        </div>

                        <div class="form-group">
                            <label class="form-label">Cấp độ HSK <span class="text-danger">*</span></label>
                            <select name="hskLevel" class="form-select" required>
                                <option value="1" ${word.hskLevel eq 1 or empty word ? 'selected' : ''}>HSK 1</option>
                                <option value="2" ${word.hskLevel eq 2 ? 'selected' : ''}>HSK 2</option>
                                <option value="3" ${word.hskLevel eq 3 ? 'selected' : ''}>HSK 3</option>
                                <option value="4" ${word.hskLevel eq 4 ? 'selected' : ''}>HSK 4</option>
                                <option value="5" ${word.hskLevel eq 5 ? 'selected' : ''}>HSK 5</option>
                                <option value="6" ${word.hskLevel eq 6 ? 'selected' : ''}>HSK 6</option>
                            </select>
                        </div>
                    </div>

                    <!-- Row 2: Meaning & Topic -->
                    <div class="d-grid sm-grid-cols-3 gap-3">
                        <div class="form-group" style="grid-column: span 2;">
                            <label class="form-label">Nghĩa tiếng Việt <span class="text-danger">*</span></label>
                            <input type="text" 
                                   name="meaningVi" 
                                   class="form-control" 
                                   placeholder="vd: Xin chào" 
                                   value="${word.meaningVi}" 
                                   required />
                        </div>

                        <div class="form-group">
                            <label class="form-label">Chủ đề (Topic)</label>
                            <input type="text" 
                                   name="topic" 
                                   class="form-control" 
                                   placeholder="vd: Chào hỏi" 
                                   value="${word.topic}" />
                        </div>
                    </div>

                    <!-- Row 3: Example Sentence -->
                    <div class="form-group">
                        <label class="form-label">Câu ví dụ (Hán tự)</label>
                        <textarea name="exampleSentence" 
                                  class="form-control font-hanzi" 
                                  rows="2" 
                                  placeholder="vd: 你好！很高兴认识你。">${word.exampleSentence}</textarea>
                    </div>

                    <!-- Row 4: Example Meaning -->
                    <div class="form-group">
                        <label class="form-label">Dịch nghĩa câu ví dụ</label>
                        <textarea name="exampleMeaningVi" 
                                  class="form-control" 
                                  rows="2" 
                                  placeholder="vd: Xin chào! Rất vui được quen biết bạn.">${word.exampleMeaningVi}</textarea>
                    </div>

                    <!-- Row 5: Audio URL -->
                    <div class="form-group">
                        <label class="form-label">URL Âm thanh (Audio MP3 nếu có)</label>
                        <input type="url" 
                               name="audioUrl" 
                               class="form-control" 
                               placeholder="https://example.com/audio.mp3" 
                               value="${word.audioUrl}" />
                    </div>
                </div>

                <!-- Form Action Buttons -->
                <div class="d-flex justify-content-end gap-3 mt-6 pt-4" style="border-top: 1px solid var(--border);">
                    <a href="${pageContext.request.contextPath}/words" class="btn btn-outline">
                        Hủy bỏ
                    </a>
                    <button type="submit" class="btn btn-primary shadow-lift">
                        <i class="fa-solid fa-floppy-disk me-1"></i>
                        <c:choose>
                            <c:when test="${action eq 'edit'}">Cập nhật từ vựng</c:when>
                            <c:otherwise>Lưu từ vựng mới</c:otherwise>
                        </c:choose>
                    </button>
                </div>
            </form>
        </div>
    </div>
</div>

<jsp:include page="/common/footer.jsp" />

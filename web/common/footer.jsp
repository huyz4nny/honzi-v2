<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<footer class="site-footer">
    <div class="container">
        HonziGo · 每天一点点 — mỗi ngày một chút
    </div>
</footer>

<!-- Shared JavaScript Helpers -->
<script>
// 1. Web Speech Synthesis Pronunciation API
function speak(text) {
    if (!text || typeof window === 'undefined') return;
    if ('speechSynthesis' in window) {
        window.speechSynthesis.cancel();
        var utterance = new SpeechSynthesisUtterance(text);
        utterance.lang = 'zh-CN';
        utterance.rate = 0.85;
        window.speechSynthesis.speak(utterance);
    } else {
        console.warn('Trình duyệt không hỗ trợ Web Speech Synthesis.');
    }
}

// 2. Mobile Menu Toggle
function toggleMobileMenu() {
    var drawer = document.getElementById('mobileMenuDrawer');
    if (drawer) {
        drawer.classList.toggle('show');
    }
}

// 3. 3D Flip Card Toggle
function toggleCardFlip(cardElement) {
    var flipper = cardElement || document.querySelector('.card-flipper');
    if (flipper) {
        flipper.classList.toggle('card-flipped');
    }
}

// 4. Modal Helpers
var hanziModal = {
    show: function(id) {
        var el = document.getElementById(id);
        if (el) el.classList.add('show');
    },
    hide: function(id) {
        var el = document.getElementById(id);
        if (el) el.classList.remove('show');
    }
};

// 5. Global Tab Switching Logic
document.addEventListener('DOMContentLoaded', function() {
    document.querySelectorAll('.tab-btn').forEach(function(btn) {
        btn.addEventListener('click', function() {
            var targetId = btn.getAttribute('data-tab-target');
            if (!targetId) return;

            // Remove active from all tab buttons in this container
            var container = btn.closest('.card-plain') || document;
            container.querySelectorAll('.tab-btn').forEach(function(b) {
                b.classList.remove('active');
            });
            container.querySelectorAll('.tab-content-panel').forEach(function(p) {
                p.classList.remove('active');
            });

            btn.classList.add('active');
            var targetPanel = document.getElementById(targetId);
            if (targetPanel) targetPanel.classList.add('active');
        });
    });

    // Close modal when clicking backdrop
    document.querySelectorAll('.modal-backdrop').forEach(function(backdrop) {
        backdrop.addEventListener('click', function(e) {
            if (e.target === backdrop) {
                backdrop.classList.remove('show');
            }
        });
    });
});
</script>
</body>
</html>

-- ========================================================
-- SCRIPT TẠO DATABASE VÀ DỮ LIỆU ĐẦY ĐỦ CHO HANZI GO (HSK 1 - HSK 6)
-- Hệ quản trị CSDL: Microsoft SQL Server (SSMS 18 / 19 / 20)
-- ========================================================

-- 1. Tạo Database HanziGoDB
IF NOT EXISTS (SELECT * FROM sys.databases WHERE name = 'HanziGoDB')
BEGIN
    CREATE DATABASE HanziGoDB;
END
GO

USE HanziGoDB;
GO

-- Xóa bảng cũ nếu đã tồn tại theo đúng thứ tự khóa ngoại
IF OBJECT_ID('dbo.QuizResults', 'U') IS NOT NULL DROP TABLE dbo.QuizResults;
IF OBJECT_ID('dbo.UserProgress', 'U') IS NOT NULL DROP TABLE dbo.UserProgress;
IF OBJECT_ID('dbo.Words', 'U') IS NOT NULL DROP TABLE dbo.Words;
IF OBJECT_ID('dbo.Users', 'U') IS NOT NULL DROP TABLE dbo.Users;
GO

-- 2. Bảng Users (Người dùng & Quản trị viên)
CREATE TABLE Users (
    UserID INT IDENTITY(1,1) PRIMARY KEY,
    Username NVARCHAR(50) NOT NULL UNIQUE,
    PasswordHash NVARCHAR(255) NOT NULL,
    Email NVARCHAR(100) NOT NULL UNIQUE,
    Role NVARCHAR(20) NOT NULL DEFAULT 'USER', -- 'ADMIN' hoặc 'USER'
    CreatedAt DATETIME DEFAULT GETDATE()
);
GO

-- 3. Bảng Words (Từ vựng tiếng Trung chuẩn HSK 1 - HSK 6)
CREATE TABLE Words (
    WordID INT IDENTITY(1,1) PRIMARY KEY,
    Hanzi NVARCHAR(50) NOT NULL,
    Pinyin NVARCHAR(100) NOT NULL,
    MeaningVi NVARCHAR(255) NOT NULL,
    HskLevel INT NOT NULL CHECK (HskLevel BETWEEN 1 AND 6),
    Topic NVARCHAR(100) DEFAULT N'Từ vựng chung',
    ExampleSentence NVARCHAR(500),
    ExampleMeaningVi NVARCHAR(500),
    AudioUrl NVARCHAR(255)
);
GO

-- 4. Bảng UserProgress (Tiến độ học tập Flashcard cá nhân)
CREATE TABLE UserProgress (
    ProgressID INT IDENTITY(1,1) PRIMARY KEY,
    UserID INT NOT NULL,
    WordID INT NOT NULL,
    Status NVARCHAR(20) NOT NULL DEFAULT 'New', -- 'New', 'Learning', 'Mastered'
    CorrectCount INT DEFAULT 0,
    WrongCount INT DEFAULT 0,
    LastReviewedAt DATETIME DEFAULT GETDATE(),
    NextReviewAt DATETIME,
    CONSTRAINT FK_UserProgress_User FOREIGN KEY (UserID) REFERENCES Users(UserID) ON DELETE CASCADE,
    CONSTRAINT FK_UserProgress_Word FOREIGN KEY (WordID) REFERENCES Words(WordID) ON DELETE CASCADE,
    CONSTRAINT UQ_User_Word UNIQUE (UserID, WordID)
);
GO

-- 5. Bảng QuizResults (Lịch sử làm bài kiểm tra trắc nghiệm)
CREATE TABLE QuizResults (
    QuizID INT IDENTITY(1,1) PRIMARY KEY,
    UserID INT NOT NULL,
    HskLevel INT NOT NULL,
    Score INT NOT NULL,
    TotalQuestions INT NOT NULL DEFAULT 10,
    TakenAt DATETIME DEFAULT GETDATE(),
    CONSTRAINT FK_QuizResults_User FOREIGN KEY (UserID) REFERENCES Users(UserID) ON DELETE CASCADE
);
GO

-- ========================================================
-- TẠO TÀI KHOẢN ADMIN DUY NHẤT
-- Username: admin
-- Mật khẩu: admin
-- Mã băm SHA-256: 8c6976e5b5410415bde908bd4dee15dfb167a9c873fc4bb8a81f6f2ab448a918
-- ========================================================
INSERT INTO Users (Username, PasswordHash, Email, Role) VALUES
(N'admin', N'8c6976e5b5410415bde908bd4dee15dfb167a9c873fc4bb8a81f6f2ab448a918', N'admin@hanzigo.com', N'ADMIN');
GO

-- ========================================================
-- KHO DỮ LIỆU TỪ VỰNG CHUẨN ĐẦY ĐỦ TỪ HSK 1 ĐẾN HSK 6
-- ========================================================

-- --------------------------------------------------------
-- CẤP ĐỘ HSK 1 (Nền tảng: Chào hỏi, gia đình, số đếm, sinh hoạt)
-- --------------------------------------------------------
INSERT INTO Words (Hanzi, Pinyin, MeaningVi, HskLevel, Topic, ExampleSentence, ExampleMeaningVi, AudioUrl) VALUES
(N'你好', N'nǐ hǎo', N'Xin chào', 1, N'Chào hỏi', N'你好！很高兴认识你。', N'Xin chào! Rất vui được quen biết bạn.', N''),
(N'谢谢', N'xiè xie', N'Cảm ơn', 1, N'Giao tiếp', N'太谢谢你了。', N'Vô cùng cảm ơn bạn.', N''),
(N'再见', N'zài jiàn', N'Tạm biệt', 1, N'Chào hỏi', N'老师，明天见，再见！', N'Thưa thầy, hẹn gặp lại ngày mai, tạm biệt!', N''),
(N'中国', N'zhōng guó', N'Trung Quốc', 1, N'Quốc gia', N'我非常喜欢中国文化。', N'Tôi rất thích văn hóa Trung Quốc.', N''),
(N'老师', N'lǎo shī', N'Thầy/Cô giáo', 1, N'Nghề nghiệp', N'王老师是我们的汉语老师。', N'Thầy Vương là giáo viên tiếng Trung của chúng tôi.', N''),
(N'学生', N'xué sheng', N'Học sinh / Sinh viên', 1, N'Trường học', N'他是一个非常努力的学生。', N'Cậu ấy là một học sinh rất chăm chỉ.', N''),
(N'朋友', N'péng you', N'Bạn bè', 1, N'Quan hệ', N'我们是认识多年的好朋友。', N'Chúng tôi là bạn tốt quen nhau nhiều năm.', N''),
(N'爸爸', N'bà ba', N'Bố / Cha', 1, N'Gia đình', N'我爸爸在医院工作。', N'Bố tôi làm việc ở bệnh viện.', N''),
(N'妈妈', N'mā ma', N'Mẹ', 1, N'Gia đình', N'妈妈做饭做得很好吃。', N'Mẹ nấu ăn rất ngon.', N''),
(N'水', N'shuǐ', N'Nước', 1, N'Đồ uống', N'天气热，多喝一点水吧。', N'Trời nóng, hãy uống thêm chút nước nhé.', N''),
(N'茶', N'chá', N'Trà', 1, N'Đồ uống', N'中国人有喝热茶的习惯。', N'Người Trung Quốc có thói quen uống trà nóng.', N''),
(N'米饭', N'mǐ fàn', N'Cơm', 1, N'Ăn uống', N'今天中午我们吃米饭和牛肉。', N'Trưa nay chúng ta ăn cơm và thịt bò.', N''),
(N'吃', N'chī', N'Ăn', 1, N'Hành động', N'你想吃什么中国菜？', N'Bạn muốn ăn món Trung Quốc nào?', N''),
(N'喝', N'hē', N'Uống', 1, N'Hành động', N'我想喝一杯冰咖啡。', N'Tôi muốn uống một ly cà phê đá.', N''),
(N'苹果', N'píng guǒ', N'Quả táo', 1, N'Hoa quả', N'桌子上有三个大苹果。', N'Trên bàn có 3 quả táo to.', N''),
(N'猫', N'māo', N'Con mèo', 1, N'Động vật', N'这只小猫非常可爱。', N'Chú mèo con này rất đáng yêu.', N''),
(N'狗', N'gǒu', N'Con chó', 1, N'Động vật', N'我家有一只黑色的狗。', N'Nhà tôi có một chú chó màu đen.', N''),
(N'书', N'shū', N'Sách', 1, N'Học tập', N'我买了一本新的汉语书。', N'Tôi đã mua một cuốn sách tiếng Trung mới.', N''),
(N'电脑', N'diàn nǎo', N'Máy tính', 1, N'Công nghệ', N'我每天用电脑工作。', N'Mỗi ngày tôi đều dùng máy tính làm việc.', N''),
(N'钱', N'qián', N'Tiền', 1, N'Mua sắm', N'请问这件衣服多少钱？', N'Xin hỏi bộ quần áo này bao nhiêu tiền?', N''),
(N'喜欢', N'xǐ huan', N'Thích', 1, N'Cảm xúc', N'我非常喜欢学汉字。', N'Tôi rất thích học chữ Hán.', N''),
(N'学习', N'xué xí', N'Học tập', 1, N'Hành động', N'我们要认真学习汉语。', N'Chúng ta phải chăm chỉ học tiếng Trung.', N''),
(N'看', N'kàn', N'Xem / Nhìn / Đọc', 1, N'Hành động', N'周末我喜欢在家看电影。', N'Cuối tuần tôi thích ở nhà xem phim.', N''),
(N'去', N'qù', N'Đi', 1, N'Hành động', N'明天我想去商店买东西。', N'Ngày mai tôi muốn đi cửa hàng mua đồ.', N''),
(N'大', N'dà', N'To / Lớn', 1, N'Tính từ', N'北京是一个很大的城市。', N'Bắc Kinh là một thành phố rất lớn.', N'');

-- --------------------------------------------------------
-- CẤP ĐỘ HSK 2 (Giao tiếp thường nhật, mua sắm, phương tiện, thời gian)
-- --------------------------------------------------------
INSERT INTO Words (Hanzi, Pinyin, MeaningVi, HskLevel, Topic, ExampleSentence, ExampleMeaningVi, AudioUrl) VALUES
(N'机场', N'jī chǎng', N'Sân bay', 2, N'Giao thông', N'我正坐出租车去机场。', N'Tôi đang ngồi taxi đi ra sân bay.', N''),
(N'旅游', N'lǚ yóu', N'Du lịch', 2, N'Du lịch', N'我和朋友打算去北京旅游。', N'Tôi và bạn dự định đi du lịch Bắc Kinh.', N''),
(N'运动', N'yùn dòng', N'Vận động / Thể thao', 2, N'Sức khỏe', N'每天运动对身体很有好处。', N'Mỗi ngày vận động rất có lợi cho sức khỏe.', N''),
(N'便宜', N'pián yi', N'Rẻ (giá cả)', 2, N'Mua sắm', N'这里的苹果既新鲜又便宜。', N'Táo ở đây vừa tươi vừa rẻ.', N''),
(N'生病', N'shēng bìng', N'Bị ốm / Bị bệnh', 2, N'Sức khỏe', N'他今天生病了，不能去上课。', N'Hôm nay cậu ấy bị ốm, không thể đi học.', N''),
(N'休息', N'xiū xi', N'Nghỉ ngơi', 2, N'Sinh hoạt', N'工作累了就休息一下吧。', N'Làm việc mệt rồi thì nghỉ ngơi một chút đi.', N''),
(N'时间', N'shí jiān', N'Thời gian', 2, N'Thời gian', N'你有时间和我一起去跑步吗？', N'Bạn có thời gian đi chạy bộ cùng tôi không?', N''),
(N'帮助', N'bāng zhù', N'Giúp đỡ', 2, N'Giao tiếp', N'非常感谢你对我的热情帮助。', N'Rất cảm ơn sự giúp đỡ nhiệt tình của bạn dành cho tôi.', N''),
(N'跑步', N'pǎo bù', N'Chạy bộ', 2, N'Thể thao', N'我习惯每天早晨去公园跑步。', N'Tôi có thói quen chạy bộ ở công viên mỗi sáng sớm.', N''),
(N'颜色', N'yán sè', N'Màu sắc', 2, N'Mô tả', N'你最喜欢什么颜色？', N'Bạn thích màu sắc nào nhất?', N''),
(N'穿', N'chuān', N'Mặc (quần áo)', 2, N'Trang phục', N'外面冷，多穿一件衣服吧。', N'Bên ngoài lạnh, mặc thêm một chiếc áo đi.', N''),
(N'自行车', N'zì xíng chē', N'Xe đạp', 2, N'Giao thông', N'我每天骑自行车去学校。', N'Tôi đạp xe đạp đến trường mỗi ngày.', N''),
(N'懂', N'dǒng', N'Hiểu / Biết', 2, N'Nhận thức', N'老师说的话你听懂了吗？', N'Lời thầy giáo nói bạn nghe có hiểu không?', N''),
(N'贵', N'guì', N'Đắt (tiền)', 2, N'Mua sắm', N'这件大衣质量好，但是有点贵。', N'Chiếc áo khoác này chất lượng tốt, nhưng hơi đắt.', N''),
(N'准备', N'zhǔn bèi', N'Chuẩn bị', 2, N'Hành động', N'我已经准备好参加考试了。', N'Tôi đã chuẩn bị sẵn sàng để tham gia kỳ thi.', N''),
(N'介绍', N'jiè shào', N'Giới thiệu', 2, N'Giao tiếp', N'请让我自我介绍一下。', N'Xin hãy để tôi tự giới thiệu một chút.', N''),
(N'开始', N'kāi shǐ', N'Bắt đầu', 2, N'Thời gian', N'会议将在上午九点开始。', N'Cuộc họp sẽ bắt đầu lúc 9 giờ sáng.', N''),
(N'欢迎', N'huān yíng', N'Hoan nghênh / Chào đón', 2, N'Chào hỏi', N'欢迎你来到我们公司工作！', N'Chào mừng bạn đến công ty chúng tôi làm việc!', N''),
(N'铅笔', N'qiān bǐ', N'Bút chì', 2, N'Học tập', N'请借我一支铅笔用一下。', N'Làm ơn cho tôi mượn một cây bút chì dùng chút.', N''),
(N'晴', N'qíng', N'Trời nắng / Nắng ráo', 2, N'Thời tiết', N'今天天气晴朗，很适合出门。', N'Hôm nay trời nắng ráo, rất thích hợp ra ngoài.', N'');

-- --------------------------------------------------------
-- CẤP ĐỘ HSK 3 (Giao tiếp học tập, làm việc, biểu đạt cảm xúc, ý kiến)
-- --------------------------------------------------------
INSERT INTO Words (Hanzi, Pinyin, MeaningVi, HskLevel, Topic, ExampleSentence, ExampleMeaningVi, AudioUrl) VALUES
(N'环境', N'huán jìng', N'Môi trường', 3, N'Đời sống', N'保护自然环境是每个人的责任。', N'Bảo vệ môi trường tự nhiên là trách nhiệm của mỗi người.', N''),
(N'健康', N'jiàn kāng', N'Sức khỏe / Khỏe mạnh', 3, N'Sức khỏe', N'祝你身体健康，工作顺利！', N'Chúc bạn thân thể khỏe mạnh, công việc thuận lợi!', N''),
(N'解决', N'jiě jué', N'Giải quyết', 3, N'Công việc', N'我们要想办法尽快解决这个问题。', N'Chúng ta phải nghĩ cách giải quyết vấn đề này càng sớm càng tốt.', N''),
(N'成绩', N'chéng jì', N'Thành tích / Điểm số', 3, N'Học tập', N'他的这次考试成绩非常优秀。', N'Thành tích thi lần này của cậu ấy vô cùng xuất sắc.', N''),
(N'交流', N'jiāo liú', N'Giao lưu / Trao đổi', 3, N'Giao tiếp', N'多与母语者交流有助于提高口语。', N'Giao lưu nhiều với người bản ngữ giúp nâng cao khẩu ngữ.', N''),
(N'习惯', N'xí guàn', N'Thói quen / Tập quán', 3, N'Đời sống', N'早睡早起是一个非常好的习惯。', N'Ngủ sớm dậy sớm là một thói quen rất tốt.', N''),
(N'选择', N'xuǎn zé', N'Lựa chọn', 3, N'Quyết định', N'面对机会，你要勇敢做出选择。', N'Đối diện với cơ hội, bạn cần dũng cảm đưa ra lựa chọn.', N''),
(N'要求', N'yāo qiú', N'Yêu cầu', 3, N'Công việc', N'老板对工作的质量要求很高。', N'Sếp có yêu cầu rất cao đối với chất lượng công việc.', N''),
(N'愿意', N'yuàn yì', N'Sẵn lòng / Bằng lòng', 3, N'Cảm xúc', N'你愿意和我一起去旅行吗？', N'Bạn có sẵn lòng đi du lịch cùng tôi không?', N''),
(N'认真', N'rèn zhēn', N'Chăm chỉ / Nghiêm túc', 3, N'Thái độ', N'他做事情总是非常认真负责。', N'Cậu ấy làm việc luôn rất nghiêm túc và có trách nhiệm.', N''),
(N'机会', N'jī huì', N'Cơ hội', 3, N'Đời sống', N'不要错过出国留学的宝贵机会。', N'Đừng bỏ lỡ cơ hội quý giá đi du học nước ngoài.', N''),
(N'简单', N'jiǎn dān', N'Đơn giản', 3, N'Tính chất', N'这个问题其实没有想象中那么简单。', N'Vấn đề này thực ra không đơn giản như tưởng tượng.', N''),
(N'热情', N'rè qíng', N'Nhiệt tình / Nồng hậu', 3, N'Tính cách', N'中国人民对待外国朋友非常热情。', N'Người dân Trung Quốc đối đãi với bạn bè quốc tế rất nhiệt tình.', N''),
(N'清楚', N'qīng chu', N'Rõ ràng / Sáng tỏ', 3, N'Nhận thức', N'请把你的想法说清楚一点。', N'Xin hãy nói rõ ràng hơn ý kiến của bạn.', N''),
(N'担心', N'dān xīn', N'Lo lắng', 3, N'Cảm xúc', N'别担心，一切都会好起来的。', N'Đừng lo lắng, mọi chuyện rồi sẽ tốt đẹp lên thôi.', N''),
(N'特别', N'tè bié', N'Đặc biệt', 3, N'Mô tả', N'这道菜的味道特别棒。', N'Hương vị của món ăn này đặc biệt tuyệt vời.', N''),
(N'突然', N'tū rán', N'Đột nhiên / Bất ngờ', 3, N'Trạng thái', N'刚才外面突然下起了大雨。', N'Vừa rồi bên ngoài đột nhiên đổ cơn mưa to.', N''),
(N'相信', N'xiāng xìn', N'Tin tưởng', 3, N'Cảm xúc', N'我相信你一定能够取得成功。', N'Tôi tin tưởng bạn nhất định sẽ giành được thành công.', N''),
(N'明白', N'míng bai', N'Hiểu rõ / Minh bạch', 3, N'Nhận thức', N'听了老师的解释，大家都明白了。', N'Nghe thầy giải thích xong, mọi người đều hiểu rõ.', N''),
(N'影响', N'yǐng xiǎng', N'Ảnh hưởng', 3, N'Đời sống', N'看手机太久会影响视力。', N'Xem điện thoại quá lâu sẽ ảnh hưởng thị lực.', N'');

-- --------------------------------------------------------
-- CẤP ĐỘ HSK 4 (Thảo luận sâu, tin tức, văn hóa, công sở, thương mại)
-- --------------------------------------------------------
INSERT INTO Words (Hanzi, Pinyin, MeaningVi, HskLevel, Topic, ExampleSentence, ExampleMeaningVi, AudioUrl) VALUES
(N'压力', N'yā lì', N'Áp lực', 4, N'Tâm lý', N'现代人在工作上面临很大的压力。', N'Người hiện đại đối mặt với áp lực rất lớn trong công việc.', N''),
(N'标准', N'biāo zhǔn', N'Tiêu chuẩn', 4, N'Đánh giá', N'他的普通话发音非常标准。', N'Phát âm tiếng phổ thông của anh ấy rất chuẩn.', N''),
(N'责任', N'zé rèn', N'Trách nhiệm', 4, N'Đạo đức', N'每个人都应该对自己做的事承担责任。', N'Mỗi người đều nên chịu trách nhiệm cho những việc mình làm.', N''),
(N'经验', N'jīng yàn', N'Kinh nghiệm', 4, N'Công việc', N'他在软件开发领域有丰富的经验。', N'Anh ấy có kinh nghiệm phong phú trong lĩnh vực phát triển phần mềm.', N''),
(N'成功', N'chéng gōng', N'Thành công', 4, N'Thành tựu', N'坚持不懈是走向成功的关键。', N'Kiên trì bền bỉ là chìa khóa bước tới thành công.', N''),
(N'鼓励', N'gǔ lì', N'Khích lệ / Động viên', 4, N'Giao tiếp', N'老师经常鼓励我们要多开口说汉语。', N'Thầy giáo thường xuyên động viên chúng tôi phải nói nhiều tiếng Trung.', N''),
(N'究竟', N'jiū jìng', N'Rốt cuộc / Rốt cục', 4, N'Tư duy', N'你究竟想要表达什么意思？', N'Rốt cuộc bạn muốn biểu đạt ý tứ gì?', N''),
(N'质量', N'zhì liàng', N'Chất lượng', 4, N'Thương mại', N'我们必须严格把控产品的质量。', N'Chúng ta phải kiểm soát nghiêm ngặt chất lượng sản phẩm.', N''),
(N'复杂', N'fù zá', N'Phức tạp', 4, N'Tính chất', N'这个问题背后的原因非常复杂。', N'Nguyên nhân đằng sau vấn đề này vô cùng phức tạp.', N''),
(N'详细', N'xiáng xì', N'Chi tiết / Tỉ mỉ', 4, N'Công việc', N'这份报告详细列出了所有数据。', N'Bản báo cáo này đã liệt kê chi tiết toàn bộ số liệu.', N''),
(N'安排', N'ān pái', N'Sắp xếp / Bố trí', 4, N'Công việc', N'请把下周的行程提前安排好。', N'Hãy sắp xếp lịch trình tuần sau từ trước.', N''),
(N'积极', N'jī jí', N'Tích cực', 4, N'Thái độ', N'我们要以积极的心态面对困难。', N'Chúng ta cần đối mặt với khó khăn bằng tâm thái tích cực.', N''),
(N'幽默', N'yōu mò', N'Hài hước / Hóm hỉnh', 4, N'Tính cách', N'他是一个非常幽默风趣的讲师。', N'Thầy ấy là một giảng viên vô cùng hài hước dí dỏm.', N''),
(N'按时', N'àn shí', N'Đúng giờ', 4, N'Thời gian', N'请大家按时到达会议室。', N'Xin mọi người hãy đến phòng họp đúng giờ.', N''),
(N'保护', N'bǎo hù', N'Bảo vệ', 4, N'Hành động', N'保护珍稀动植物是全社会的责任。', N'Bảo vệ động thực vật quý hiếm là trách nhiệm của toàn xã hội.', N''),
(N'普遍', N'pǔ biàn', N'Phổ biến', 4, N'Xã hội', N'移动支付在中国已经非常普遍。', N'Thanh toán di động ở Trung Quốc đã vô cùng phổ biến.', N''),
(N'严格', N'yán gé', N'Nghiêm khắc / Nghiêm ngặt', 4, N'Quản lý', N'学校对学生的考勤管理很严格。', N'Nhà trường quản lý điểm danh học sinh rất nghiêm ngặt.', N''),
(N'适应', N'shì yìng', N'Thích nghi / Thích ứng', 4, N'Đời sống', N'来到新的环境需要一段时间来适应。', N'Đến môi trường mới cần một khoảng thời gian để thích nghi.', N''),
(N'商量', N'shāng liang', N'Thương lượng / Bàn bạc', 4, N'Giao tiếp', N'这件事我们需要开会好好商量一下。', N'Chuyện này chúng ta cần họp lại bàn bạc kỹ lưỡng.', N''),
(N'同情', N'tóng qíng', N'Đồng cảm / Cảm thông', 4, N'Cảm xúc', N'听到他的不幸遭遇，大家都深表同情。', N'Nghe hoàn cảnh không may của cậu ấy, mọi người đều sâu sắc cảm thông.', N'');

-- --------------------------------------------------------
-- CẤP ĐỘ HSK 5 (Đọc báo, tài liệu chuyên ngành, nghị luận, văn học)
-- --------------------------------------------------------
INSERT INTO Words (Hanzi, Pinyin, MeaningVi, HskLevel, Topic, ExampleSentence, ExampleMeaningVi, AudioUrl) VALUES
(N'效率', N'xiào lǜ', N'Hiệu suất / Năng suất', 5, N'Kinh tế', N'提高工作效率是企业发展的核心。', N'Nâng cao hiệu suất làm việc là cốt lõi trong phát triển doanh nghiệp.', N''),
(N'投资', N'tóu zī', N'Đầu tư', 5, N'Tài chính', N'投资股市存在一定的市场风险。', N'Đầu tư thị trường chứng khoán tồn tại rủi ro nhất định.', N''),
(N'逻辑', N'luó ji', N'Lô-gíc / Logic', 5, N'Tư duy', N'这篇学术论文的论证逻辑十分严密。', N'Logic lập luận của bài luận văn học thuật này rất chặt chẽ.', N''),
(N'挑战', N'tiǎo zhàn', N'Thử thách / Thách thức', 5, N'Phát triển', N'面对未知的挑战，我们要勇往直前。', N'Đối diện với thử thách chưa biết, chúng ta hãy dũng cảm tiến lên.', N''),
(N'启发', N'qǐ fā', N'Khơi gợi / Truyền cảm hứng', 5, N'Tư duy', N'这部纪录片给了我极大的思想启发。', N'Bộ phim tài liệu này đã đem lại cho tôi sự gợi mở tư tưởng to lớn.', N''),
(N'资源', N'zī yuán', N'Tài nguyên / Nguồn lực', 5, N'Kinh tế', N'合理利用自然资源促进可持续发展。', N'Sử dụng hợp lý tài nguyên thiên nhiên thúc đẩy phát triển bền vững.', N''),
(N'具备', N'jù bèi', N'Trang bị đủ / Có sẵn', 5, N'Năng lực', N'应聘该岗位需要具备扎实的专业知识。', N'Ứng tuyển vị trí này cần trang bị vững vàng kiến thức chuyên môn.', N''),
(N'趋势', N'qū shì', N'Xu hướng / Chiều hướng', 5, N'Phân tích', N'绿色低碳发展是当今国际社会的大趋势。', N'Phát triển xanh giảm phát thải là xu hướng lớn của xã hội quốc tế ngày nay.', N''),
(N'把握', N'bǎ wò', N'Nắm bắt / Nắm chắc', 5, N'Hành động', N'我们要牢牢把握时代的数字化机遇。', N'Chúng ta cần nắm bắt vững chắc cơ hội chuyển đổi số của thời đại.', N''),
(N'促进', N'cù jìn', N'Thúc đẩy / Xúc tiến', 5, N'Phát triển', N'文化交流有力促进了两国人民的友谊。', N'Giao lưu văn hóa đã thúc đẩy mạnh mẽ tình hữu nghị giữa nhân dân hai nước.', N''),
(N'克服', N'kè fú', N'Khắc phục / Vượt qua', 5, N'Nghị lực', N'大家齐心协力克服了施工中的重重困难。', N'Mọi người đồng lòng hiệp lực vượt qua muôn vàn khó khăn trong thi công.', N''),
(N'原则', N'yuán zé', N'Nguyên tắc', 5, N'Chuẩn mực', N'在谈判中我们必须坚守自己的底线和原则。', N'Trong đàm phán chúng ta phải giữ vững ranh giới và nguyên tắc của mình.', N''),
(N'核心', N'hé xīn', N'Cốt lõi / Trọng tâm', 5, N'Chiến lược', N'创新是推动现代科技发展的核心动力。', N'Đổi mới sáng tạo là động lực cốt lõi thúc đẩy phát triển công nghệ hiện đại.', N''),
(N'措施', N'cuò shī', N'Biện pháp / Giải pháp', 5, N'Quản lý', N'政府出台了多项扶持中小企业的有力措施。', N'Chính phủ đã ban hành nhiều biện pháp mạnh mẽ hỗ trợ doanh nghiệp vừa và nhỏ.', N''),
(N'显著', N'xiǎn zhù', N'Đáng kể / Nổi bật', 5, N'Đánh giá', N'经过一年的努力，他的汉语水平有了显著提升。', N'Sau một năm nỗ lực, trình độ tiếng Trung của anh ấy đã tiến bộ rõ rệt.', N''),
(N'沟通', N'gōu tōng', N'Giao tiếp / Trao đổi thông tin', 5, N'Giao tiếp', N'良好的沟通是团队高效协作的基础。', N'Giao tiếp tốt là nền tảng cho sự cộng tác hiệu quả của đội ngũ.', N''),
(N'深刻', N'shēn kè', N'Sâu sắc', 5, N'Nhận thức', N'这次经历给我留下了终生难忘的深刻印象。', N'Trải nghiệm lần này đã để lại cho tôi ấn tượng sâu sắc suốt đời khó quên.', N''),
(N'贡献', N'gòng xiàn', N'Cống hiến / Đóng góp', 5, N'Xã hội', N'他为国家医学科研事业做出了巨大贡献。', N'Ông đã có đóng góp to lớn cho sự nghiệp nghiên cứu y học quốc gia.', N''),
(N'证据', N'zhèng jù', N'Bằng chứng / Chứng cứ', 5, N'Pháp lý', N'法官判决案件必须依靠充分确凿的证据。', N'Thẩm phán phán quyết vụ án phải dựa vào chứng cứ đầy đủ và xác thực.', N''),
(N'协调', N'xié tiáo', N'Điều phối / Hài hòa', 5, N'Quản trị', N'项目经理需要协调各个部门之间的协作关系。', N'Quản lý dự án cần điều phối mối quan hệ cộng tác giữa các phòng ban.', N'');

-- --------------------------------------------------------
-- CẤP ĐỘ HSK 6 (Bản ngữ, văn ngôn, học thuật, triết học, nghệ thuật)
-- --------------------------------------------------------
INSERT INTO Words (Hanzi, Pinyin, MeaningVi, HskLevel, Topic, ExampleSentence, ExampleMeaningVi, AudioUrl) VALUES
(N'渊博', N'yuān bó', N'Uyên bác / Uyên thâm', 6, N'Học thuật', N'老教授学识渊博，深受广大学生的敬佩。', N'Vị giáo sư già học thức uyên bác, được đông đảo sinh viên kính trọng.', N''),
(N'兼顾', N'jiān gù', N'Kiêm toàn / Quan tâm đồng thời', 6, N'Chiến lược', N'制定政策时要兼顾经济效益与环境保护。', N'Khi ban hành chính sách cần quan tâm đồng thời hiệu quả kinh tế và bảo vệ môi trường.', N''),
(N'贯彻', N'guàn chè', N'Quán triệt / Thực hiện triệt để', 6, N'Chính sách', N'全公司必须坚定贯彻执行新的安全生产规章。', N'Toàn thể công ty phải kiên định quán triệt thực thi quy chế an toàn sản xuất mới.', N''),
(N'陶冶', N'táo yě', N'Rèn giũa / Hun đúc (tâm hồn)', 6, N'Văn hóa', N'欣赏古典音乐能够很好地陶冶人的情操。', N'Thưởng thức âm nhạc cổ điển có thể hun đúc rất tốt tâm hồn con người.', N''),
(N'精打细算', N'jīng dǎ xì suàn', N'Tính toán tỉ mỉ / Chắt chiu', 6, N'Thành ngữ', N'创业初期，每一笔资金开支都需要精打细算。', N'Giai đoạn đầu khởi nghiệp, từng khoản chi tiêu tài chính đều cần tính toán tỉ mỉ.', N''),
(N'举世瞩目', N'jǔ shì zhǔ mù', N'Toàn thế giới dõi theo / Vang dội', 6, N'Thành ngữ', N'中国航天工程取得了举世瞩目的辉煌成就。', N'Ngành công nghiệp vũ trụ Trung Quốc đã đạt thành tựu rực rỡ khiến toàn thế giới dõi theo.', N''),
(N'不可思议', N'bù kě sī yì', N'Kỳ diệu khó tin / Không thể tưởng tượng', 6, N'Thành ngữ', N'古人建造万里长城的宏伟工程令人感到不可思议。', N'Công trình vĩ đại người xưa xây dựng Vạn Lý Trường Thành khiến người ta cảm thấy kỳ diệu khó tin.', N''),
(N'络绎不绝', N'luò yì bù jué', N'Nườm nượp không ngớt', 6, N'Thành ngữ', N'旅游旺季，来自各地的游客络绎不绝。', N'Mùa cao điểm du lịch, du khách từ khắp nơi đổ về nườm nượp không ngớt.', N''),
(N'兢兢业业', N'jīng jīng yè yè', N'Cần mẫn / Tận tụy', 6, N'Thành ngữ', N'他在教育岗位上兢兢业业奉献了三十年。', N'Thầy đã cần mẫn cống hiến 30 năm trên cương vị giáo dục.', N''),
(N'循序渐进', N'xún xù jiàn jìn', N'Từng bước tiến bộ / Tuần tự tiệm tiến', 6, N'Thành ngữ', N'掌握一门外语必须遵循循序渐进的学习法则。', N'Làm chủ một ngoại ngữ phải tuân theo quy luật học tập từng bước tiến lên.', N''),
(N'潜移默化', N'qián yí mò huà', N'Thấm nhuần tự nhiên / Mưa dầm thấm lâu', 6, N'Thành ngữ', N'家庭的良好家风对孩子的成长起着潜移默化的影响。', N'Gia phong tốt đẹp trong gia đình có ảnh hưởng thấm nhuần sâu sắc tới sự trưởng thành của con trẻ.', N''),
(N'微不足道', N'wēi bù zú dào', N'Nhỏ bé không đáng kể', 6, N'Thành ngữ', N'相比浩瀚的宇宙，个人的烦恼显得微不足道。', N'So với vũ trụ bao la, những muộn phiền cá nhân trở nên nhỏ bé không đáng kể.', N''),
(N'变幻莫测', N'biàn huàn mò cè', N'Biến ảo khôn lường', 6, N'Thành ngữ', N'高山之巅的天气常常变幻莫测。', N'Thời tiết trên đỉnh núi cao thường biến ảo khôn lường.', N''),
(N'侃侃而谈', N'kǎn kǎn ér tán', N'Nói năng đĩnh đạc / Hùng hồn', 6, N'Thành ngữ', N'在国际论坛上，他面对记者的问题侃侃而谈。', N'Tại diễn đàn quốc tế, ông tự tin đĩnh đạc trả lời các câu hỏi của phóng viên.', N''),
(N'精益求精', N'jīng yì qiú jīng', N'Đã tốt còn muốn tốt hơn / Đạt đỉnh cao hoàn mỹ', 6, N'Thành ngữ', N'工匠精神的核心就是对工艺精益求精的执着追求。', N'Cốt lõi của tinh thần nghệ nhân chính là sự kiên trì theo đuổi đỉnh cao hoàn mỹ trong chế tác.', N''),
(N'深谋远虑', N'shēn móu yuǎn lǜ', N'Mưu sâu tính xa / Tầm nhìn xa trông rộng', 6, N'Thành ngữ', N'企业家需要具备深谋远虑的战略眼光。', N'Doanh nhân cần trang bị tầm nhìn chiến lược sâu sắc và nhìn xa trông rộng.', N''),
(N'见异思迁', N'jiàn yì sī qiān', N'Đứng núi này trông núi nọ / Hay thay đổi', 6, N'Thành ngữ', N'做学问最忌讳见异思迁，缺乏持之以恒的定力。', N'Làm học vấn tối kỵ đứng núi này trông núi nọ, thiếu định lực kiên trì bền bỉ.', N''),
(N'推陈出新', N'tuī chén chū xīn', N'Gạt bỏ cũ tạo ra cái mới / Đổi mới sáng tạo', 6, N'Thành ngữ', N'传统艺术只有不断推陈出新才能保持长久的生命力。', N'Nghệ thuật truyền thống chỉ khi liên tục đổi mới sáng tạo mới có thể duy trì sức sống dài lâu.', N''),
(N'同舟共济', N'tóng zhōu gòng jì', N'Cùng chung một thuyền / Đồng lòng vượt bão', 6, N'Thành ngữ', N'面对全球性危机，各国唯有同舟共济才能共克时艰。', N'Đối diện khủng hoảng toàn cầu, các quốc gia chỉ có cùng chung một thuyền mới vượt qua thời điểm gian nan.', N''),
(N'厚积薄发', N'hòu jī bó fā', N'Tích lũy dày tỏa sáng sâu / Nén sâu bật xa', 6, N'Thành ngữ', N'多年的默默钻研让他终于迎来了厚积薄发的辉煌时刻。', N'Nhiều năm âm thầm nghiên cứu cuối cùng đã giúp anh đón nhận thời khắc tỏa sáng rực rỡ từ sự tích lũy dày dặn.', N'');
GO

PRINT N'=== ĐÃ KHỞI TẠO XONG DATABASE HanziGoDB VỚI TÀI KHOẢN ADMIN DUY NHẤT VÀ KHO TỪ VỰNG ĐẦY ĐỦ TỪ HSK 1 ĐẾN HSK 6! ===';
GO

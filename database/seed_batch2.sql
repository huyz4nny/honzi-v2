-- ========================================================
-- BỔ SUNG ĐỢT 2: KHO TỪ VỰNG HSK 1 - HSK 6 MỞ RỘNG (150 TỪ MỚI)
-- ========================================================
USE HanziGoDB;
GO

-- 1. HSK 1: Thêm 25 từ cơ bản
INSERT INTO Words (Hanzi, Pinyin, MeaningVi, HskLevel, Topic, ExampleSentence, ExampleMeaningVi, AudioUrl) VALUES
(N'学校', N'xué xiào', N'Trường học', 1, N'Địa điểm', N'我们的学校很大很漂亮。', N'Trường học của chúng tôi rất to và đẹp.', N''),
(N'老师', N'lǎo shī', N'Thầy/Cô giáo', 1, N'Nghề nghiệp', N'王老师教我们学汉语。', N'Thầy Vương dạy chúng tôi học tiếng Trung.', N''),
(N'学生', N'xué sheng', N'Học sinh, sinh viên', 1, N'Trường học', N'教室里有很多认真的学生。', N'Trong lớp học có rất nhiều học sinh chăm chỉ.', N''),
(N'同学', N'tóng xué', N'Bạn cùng lớp', 1, N'Quan hệ', N'我和他是大学同学。', N'Tôi và cậu ấy là bạn học đại học.', N''),
(N'朋友', N'péng you', N'Bạn bè', 1, N'Quan hệ', N'有朋自远方来，不亦乐乎。', N'Có bạn bè từ phương xa đến, chẳng phải vui lắm sao.', N''),
(N'医生', N'yī shēng', N'Bác sĩ', 1, N'Nghề nghiệp', N'医生正在为病人看病。', N'Bác sĩ đang khám bệnh cho bệnh nhân.', N''),
(N'商店', N'shāng diàn', N'Cửa hàng', 1, N'Địa điểm', N'学校对面有一家小商店。', N'Đối diện trường học có một cửa hàng nhỏ.', N''),
(N'北京', N'běi jīng', N'Bắc Kinh', 1, N'Địa danh', N'我想去北京看看万里长城。', N'Tôi muốn đến Bắc Kinh ngắm Vạn Lý Trường Thành.', N''),
(N'中国', N'zhōng guó', N'Trung Quốc', 1, N'Quốc gia', N'中国有悠久的历史文化。', N'Trung Quốc có nền lịch sử văn hóa lâu đời.', N''),
(N'名字', N'míng zi', N'Tên gọi', 1, N'Xưng hô', N'请问你的名字怎么写？', N'Xin hỏi tên của bạn viết như thế nào?', N''),
(N'书', N'shū', N'Sách', 1, N'Học tập', N'桌子上放着几本中文书。', N'Trên bàn có đặt mấy cuốn sách tiếng Trung.', N''),
(N'字', N'zì', N'Chữ', 1, N'Ngôn ngữ', N'这个汉字你认识吗？', N'Chữ Hán này bạn có nhận biết được không?', N''),
(N'天', N'tiān', N'Ngày, trời', 1, N'Thời gian', N'今天的天气格外晴朗。', N'Thời tiết hôm nay quang đãng lạ thường.', N''),
(N'年', N'nián', N'Năm', 1, N'Thời gian', N'我在中国住了一年。', N'Tôi đã sống ở Trung Quốc một năm.', N''),
(N'月', N'yuè', N'Tháng, mặt trăng', 1, N'Thời gian', N'下个月我们要参加HSK考试。', N'Tháng sau chúng tôi sẽ tham gia kỳ thi HSK.', N''),
(N'日', N'rì', N'Ngày, mặt trời', 1, N'Thời gian', N'十月一日是国庆节。', N'Ngày một tháng mười là ngày Quốc khánh.', N''),
(N'点', N'diǎn', N'Giờ, chút ít', 1, N'Thời gian', N'现在是下午三点整。', N'Bây giờ là đúng ba giờ chiều.', N''),
(N'分钟', N'fēn zhōng', N'Phút', 1, N'Thời gian', N'请稍等五分钟。', N'Xin vui lòng chờ một lát trong năm phút.', N''),
(N'喜欢', N'xǐ huan', N'Thích', 1, N'Sở thích', N'我很喜欢学中国书法。', N'Tôi rất thích học thư pháp Trung Hoa.', N''),
(N'爱', N'ài', N'Yêu, yêu thương', 1, N'Cảm xúc', N'我爱我的家人和朋友。', N'Tôi yêu gia đình và bạn bè của tôi.', N''),
(N'想', N'xiǎng', N'Nghĩ, nhớ, muốn', 1, N'Tâm lý', N'我很想念家乡的美食。', N'Tôi rất nhớ những món ăn ngon của quê nhà.', N''),
(N'会', N'huì', N'Biết, có thể', 1, N'Kỹ năng', N'你会说一点儿汉语吗？', N'Bạn có biết nói một chút tiếng Trung không?', N''),
(N'能', N'néng', N'Có thể', 1, N'Năng lực', N'你能帮我解答这个问题吗？', N'Bạn có thể giúp tôi giải đáp câu hỏi này không?', N''),
(N'看病', N'kàn bìng', N'Khám bệnh', 1, N'Y tế', N'身体不舒服一定要去医院看病。', N'Người không khỏe nhất định phải đến bệnh viện khám bệnh.', N''),
(N'打电话', N'dǎ diàn huà', N'Gọi điện thoại', 1, N'Liên lạc', N'我正在给妈妈打电话。', N'Tôi đang gọi điện thoại cho mẹ.', N'');
GO

-- 2. HSK 2: Thêm 25 từ giao tiếp
INSERT INTO Words (Hanzi, Pinyin, MeaningVi, HskLevel, Topic, ExampleSentence, ExampleMeaningVi, AudioUrl) VALUES
(N'问', N'wèn', N'Hỏi', 2, N'Giao tiếp', N'不懂的地方请随时问老师。', N'Chỗ nào không hiểu xin cứ tự nhiên hỏi thầy cô.', N''),
(N'走', N'zǒu', N'Đi bộ, rời đi', 2, N'Hành động', N'我们走路去附近的公园。', N'Chúng mình đi bộ đến công viên gần đây.', N''),
(N'进', N'jìn', N'Vào', 2, N'Hành động', N'请进，欢迎来我家作客。', N'Xin mời vào, hoan nghênh đến chơi nhà tôi.', N''),
(N'出', N'chū', N'Ra ngoài', 2, N'Hành động', N'他刚刚走出办公室。', N'Anh ấy vừa mới bước ra khỏi văn phòng.', N''),
(N'送', N'sòng', N'Tặng, tiễn đưa', 2, N'Giao tiếp', N'这是我送给你的生日礼物。', N'Đây là món quà sinh nhật tôi tặng cho bạn.', N''),
(N'玩', N'wán', N'Chơi', 2, N'Giải trí', N'孩子们在草地上快乐地玩耍。', N'Bọn trẻ vui vẻ nô đùa trên bãi cỏ.', N''),
(N'笑', N'xiào', N'Cười', 2, N'Cảm xúc', N'听到笑话大家都会心一笑。', N'Nghe câu chuyện cười mọi người đều mỉm cười tán thưởng.', N''),
(N'哭', N'kū', N'Khóc', 2, N'Cảm xúc', N'小女孩找不到妈妈着急地哭了。', N'Cô bé không tìm thấy mẹ nên sốt ruột khóc òa lên.', N''),
(N'累', N'lèi', N'Mệt mỏi', 2, N'Sức khỏe', N'工作了一整天，他觉得很累。', N'Làm việc suốt cả ngày, anh ấy cảm thấy rất mệt.', N''),
(N'慢', N'màn', N'Chậm', 2, N'Tính từ', N'请说得慢一点儿，我能听得更清楚。', N'Xin hãy nói chậm một chút, tôi có thể nghe rõ hơn.', N''),
(N'快', N'kuài', N'Nhanh', 2, N'Tính từ', N'高铁的速度非常快。', N'Tốc độ của tàu cao tốc cực kỳ nhanh.', N''),
(N'新', N'xīn', N'Mới', 2, N'Tính từ', N'新年新气象，祝大家一切顺利。', N'Năm mới khí thế mới, chúc mọi người mọi sự thuận lợi.', N''),
(N'旧', N'jiù', N'Cũ', 2, N'Tính từ', N'这辆旧自行车陪伴了他多年。', N'Chiếc xe đạp cũ này đã đồng hành cùng anh ấy nhiều năm.', N''),
(N'远', N'yuǎn', N'Xa', 2, N'Khoảng cách', N'学校离这里不算太远。', N'Trường học cách đây không tính là quá xa.', N''),
(N'近', N'jìn', N'Gần', 2, N'Khoảng cách', N'我家离地铁站很近。', N'Nhà tôi ở rất gần ga tàu điện ngầm.', N''),
(N'长', N'cháng', N'Dài', 2, N'Kích thước', N'长江是中国最长的河流。', N'Sông Trường Giang là con sông dài nhất Trung Quốc.', N''),
(N'找', N'zhǎo', N'Tìm kiếm', 2, N'Hành động', N'我正在找我的钥匙。', N'Tôi đang tìm chiếc chìa khóa của mình.', N''),
(N'给', N'gěi', N'Cho, đưa cho', 2, N'Hành động', N'请把那本书递给我。', N'Xin hãy đưa quyển sách kia cho tôi.', N''),
(N'告诉', N'gào su', N'Bảo cho biết, nói cho', 2, N'Giao tiếp', N'他告诉了我一个好消息。', N'Anh ấy đã báo cho tôi một tin vui.', N''),
(N'事情', N'shì qing', N'Sự việc, việc', 2, N'Khái niệm', N'今天有许多重要的事情要处理。', N'Hôm nay có rất nhiều việc quan trọng cần xử lý.', N''),
(N'题', N'tí', N'Đề tài, bài tập', 2, N'Học tập', N'试卷上的每道题都要认真思考。', N'Mỗi câu hỏi trên bài thi đều phải suy nghĩ cẩn thận.', N''),
(N'虽然', N'suī rán', N'Mặc dù, tuy rằng', 2, N'Liên từ', N'虽然很难，但我绝不放弃。', N'Tuy rằng rất khó, nhưng tôi tuyệt đối không bỏ cuộc.', N''),
(N'但是', N'dàn shì', N'Nhưng mà', 2, N'Liên từ', N'他年纪虽小，但是懂得很多道理。', N'Cậu ấy tuổi tuy nhỏ, nhưng hiểu rất nhiều đạo lý.', N''),
(N'因为', N'yīn wèi', N'Bởi vì', 2, N'Liên từ', N'因为热爱，所以全力以赴。', N'Bởi vì đam mê, cho nên dốc hết toàn lực.', N''),
(N'所以', N'suǒ yǐ', N'Cho nên, vì thế', 2, N'Liên từ', N'他学习很努力，所以成绩优异。', N'Anh ấy học hành rất chăm chỉ, cho nên thành tích xuất sắc.', N'');
GO

-- 3. HSK 3: Thêm 25 từ sinh hoạt & xã hội
INSERT INTO Words (Hanzi, Pinyin, MeaningVi, HskLevel, Topic, ExampleSentence, ExampleMeaningVi, AudioUrl) VALUES
(N'相信', N'xiāng xìn', N'Tin tưởng', 3, N'Tâm lý', N'你要相信自己的潜力。', N'Bạn cần phải tin tưởng vào tiềm năng của chính mình.', N''),
(N'选择', N'xuǎn zé', N'Lựa chọn', 3, N'Hành động', N'人生面临着许多重要的选择。', N'Đời người phải đối mặt với rất nhiều sự lựa chọn quan trọng.', N''),
(N'明白', N'míng bai', N'Hiểu rõ', 3, N'Nhận thức', N'现在我终于明白其中的原因了。', N'Bây giờ tôi cuối cùng đã hiểu rõ nguyên nhân trong đó rồi.', N''),
(N'决定', N'jué dìng', N'Quyết định', 3, N'Ý chí', N'他决定毕业后去外企工作。', N'Anh ấy quyết định sau khi tốt nghiệp sẽ làm việc ở công ty nước ngoài.', N''),
(N'愿意', N'yuàn yì', N'Bằng lòng, sẵn lòng', 3, N'Ý chí', N'你愿意和我一起去图书馆吗？', N'Bạn có sẵn lòng cùng tôi đến thư viện không?', N''),
(N'敢', N'gǎn', N'Dám', 3, N'Ý chí', N'只要敢于尝试，就能有所收获。', N'Chỉ cần dám thử sức, ắt sẽ gặt hái được thành quả.', N''),
(N'打算', N'dǎ suan', N'Dự định', 3, N'Kế hoạch', N'这个周末你有什么打算？', N'Cuối tuần này bạn có dự định gì chưa?', N''),
(N'注意', N'zhù yì', N'Chú ý', 3, N'Cảnh giác', N'出门在外要注意人身安全。', N'Đi ra ngoài cần chú ý an toàn bản thân.', N''),
(N'发现', N'fā xiàn', N'Phát hiện', 3, N'Nhận thức', N'科学家发现了宇宙中新的恒星。', N'Các nhà khoa học đã phát hiện ra ngôi sao mới trong vũ trụ.', N''),
(N'要求', N'yāo qiú', N'Yêu cầu', 3, N'Quy định', N'老板对报告的要求非常严谨。', N'Sếp đặt ra yêu cầu rất nghiêm ngặt đối với bản báo cáo.', N''),
(N'关系', N'guān xì', N'Mối quan hệ', 3, N'Xã hội', N'良好的人际关系有助于事业发展。', N'Mối quan hệ nhân hòa tốt đẹp có lợi cho sự nghiệp phát triển.', N''),
(N'机会', N'jī huì', N'Cơ hội', 3, N'Đời sống', N'机会总是留给有准备的人。', N'Cơ hội luôn luôn dành cho những người có sự chuẩn bị.', N''),
(N'水平', N'shuǐ píng', N'Trình độ', 3, N'Học tập', N'经过半年努力，他的汉语水平显著提高。', N'Sau nửa năm nỗ lực, trình độ tiếng Trung của anh ấy nâng cao rõ rệt.', N''),
(N'成绩', N'chéng jì', N'Thành tích, điểm số', 3, N'Học tập', N'她在期末考试中取得了优异的成绩。', N'Cô ấy đã đạt được thành tích xuất sắc trong kỳ thi cuối kỳ.', N''),
(N'作用', N'zuò yòng', N'Tác dụng', 3, N'Tác động', N'适当的运动对健康有积极作用。', N'Vận động điều độ có tác dụng tích cực đối với sức khỏe.', N''),
(N'经常', N'jīng cháng', N'Thường xuyên', 3, N'Tần suất', N'我们应该经常锻炼身体。', N'Chúng ta nên thường xuyên rèn luyện thân thể.', N''),
(N'一直', N'yī zhí', N'Luôn luôn, thẳng', 3, N'Phó từ', N'他一直在默默地努力学习。', N'Anh ấy luôn luôn âm thầm nỗ lực học tập.', N''),
(N'其实', N'qí shí', N'Kỳ thực, thực ra', 3, N'Phó từ', N'其实学汉语并没有想象中那么难。', N'Thực ra học tiếng Trung không hề khó như trong tưởng tượng.', N''),
(N'必须', N'bì xū', N'Bắt buộc, phải', 3, N'Phó từ', N'过马路必须看清信号灯。', N'Qua đường bắt buộc phải nhìn rõ tín hiệu đèn giao thông.', N''),
(N'突然', N'tū rán', N'Đột nhiên', 3, N'Phó từ', N'外面突然下起了倾盆大雨。', N'Bên ngoài đột nhiên trút xuống cơn mưa như trút nước.', N''),
(N'刚才', N'gāng cái', N'Vừa mới đây', 3, N'Thời gian', N'刚才有人打电话找你。', N'Vừa nãy có người gọi điện thoại tìm bạn đấy.', N''),
(N'特别', N'tè bié', N'Đặc biệt', 3, N'Tính từ', N'这道菜的风味特别地道。', N'Hương vị của món ăn này đặc biệt chuẩn vị nguyên bản.', N''),
(N'重要', N'zhòng yào', N'Quan trọng', 3, N'Đánh giá', N'健康是人生中最宝贵最重要的财富。', N'Sức khỏe là tài sản quý báu và quan trọng nhất đời người.', N''),
(N'主要', N'zhǔ yào', N'Chủ yếu', 3, N'Trọng tâm', N'我们今天的主要任务是讨论方案。', N'Nhiệm vụ chủ yếu của chúng ta hôm nay là thảo luận phương án.', N''),
(N'有名', N'yǒu míng', N'Nổi tiếng', 3, N'Đánh giá', N'北京烤鸭是一道世界有名的地方特产。', N'Vịt quay Bắc Kinh là một món đặc sản địa phương nổi tiếng thế giới.', N'');
GO

-- 4. HSK 4: Thêm 25 từ nâng cao
INSERT INTO Words (Hanzi, Pinyin, MeaningVi, HskLevel, Topic, ExampleSentence, ExampleMeaningVi, AudioUrl) VALUES
(N'不仅', N'bù jǐn', N'Không những', 4, N'Liên từ', N'他不仅汉语流利，而且通晓英语。', N'Anh ấy không những tiếng Trung lưu loát mà còn thông thạo tiếng Anh.', N''),
(N'并且', N'bìng qiě', N'Đồng thời, và', 4, N'Liên từ', N'他按时完成了任务，并且质量极高。', N'Anh ấy đã hoàn thành nhiệm vụ đúng hạn, đồng thời chất lượng cực cao.', N''),
(N'反而', N'fǎn ér', N'Trái lại', 4, N'Liên từ', N'批评并没有让他气馁，反而让他更加努力。', N'Lời phê bình chẳng làm anh nản chí, trái lại càng khiến anh nỗ lực hơn.', N''),
(N'况且', N'kuàng qiě', N'Hơn nữa, vả lại', 4, N'Liên từ', N'天色已晚，况且又下着雨，别走了。', N'Trời đã tối muộn, hơn nữa lại đang đổ mưa, đừng đi nữa.', N''),
(N'既然', N'jì rán', N'Một khi đã', 4, N'Liên từ', N'既然来了，就多玩几天吧。', N'Một khi đã đến rồi thì ở lại chơi thêm vài ngày nhé.', N''),
(N'无论', N'wú lùn', N'Bất luận, dù cho', 4, N'Liên từ', N'无论前路多么漫长，我们都要坚守初心。', N'Bất luận đường trước mặt dài bao nhiêu, ta đều phải giữ vững sơ tâm.', N''),
(N'估计', N'gū jì', N'Ước tính, ước lượng', 4, N'Phán đoán', N'我估计今天下午会议就能结束。', N'Tôi ước tính chiều nay là cuộc họp có thể kết thúc rồi.', N''),
(N'怀疑', N'huái yí', N'Nghi ngờ', 4, N'Tâm lý', N'没有任何证据，不要随便怀疑他人。', N'Chưa có bất kỳ bằng chứng nào, đừng tùy tiện nghi ngờ người khác.', N''),
(N'考虑', N'kǎo lǜ', N'Cân nhắc, suy nghĩ', 4, N'Nhận thức', N'请认真考虑一下这个合作提议。', N'Xin hãy cân nhắc thật kỹ đề xuất hợp tác này.', N''),
(N'后悔', N'hòu huǐ', N'Hối hận', 4, N'Cảm xúc', N'既然做出了决定，就永远不要后悔。', N'Một khi đã đưa ra quyết định thì vĩnh viễn đừng hối hận.', N''),
(N'羡慕', N'xiàn mù', N'Ngưỡng mộ, ghen tị', 4, N'Cảm xúc', N'大家都非常羡慕他拥有美满的家庭。', N'Mọi người đều vô cùng ngưỡng mộ anh ấy có một gia đình êm ấm.', N''),
(N'同情', N'tóng qíng', N'Đồng cảm, thương cảm', 4, N'Cảm xúc', N'面对灾民的遭遇，大家深表同情并踊跃捐款。', N'Trước cảnh ngộ của đồng bào vùng lũ, ai nấy đều đồng cảm sâu sắc và ủng hộ.', N''),
(N'保护', N'bǎo hù', N'Bảo vệ', 4, N'Hành động', N'保护野生动物是维护生态平衡的根基。', N'Bảo vệ động vật hoang dã là nền móng duy trì cân bằng sinh thái.', N''),
(N'尊重', N'zūn zhòng', N'Tôn trọng', 4, N'Phẩm chất', N'学会尊重别人的观点才能赢得别人的尊重。', N'Học cách tôn trọng quan điểm của người khác mới giành được sự tôn trọng.', N''),
(N'原谅', N'yuán liàng', N'Tha thứ, lượng thứ', 4, N'Giao tiếp', N'真诚的道歉更容易得到对方的原谅。', N'Lời xin lỗi chân thành sẽ dễ dàng nhận được sự lượng thứ từ đối phương.', N''),
(N'商量', N'shāng liang', N'Bàn bạc, thương lượng', 4, N'Giao tiếp', N'这件事情我们得坐下来好好商量一下。', N'Chuyện này chúng ta cần phải ngồi lại bàn bạc cho thật kỹ.', N''),
(N'积累', N'jī lěi', N'Tích lũy', 4, N'Hành vi', N'日常工作中要注意积累宝贵的经验。', N'Trong công việc hàng ngày cần chú ý tích lũy kinh nghiệm quý báu.', N''),
(N'节约', N'jié yuē', N'Tiết kiệm', 4, N'Lối sống', N'节约用水用电是每个家庭应尽的义务。', N'Tiết kiệm điện nước là nghĩa vụ mà mỗi gia đình nên làm.', N''),
(N'浪漫', N'làng màn', N'Lãng mạn', 4, N'Cảm xúc', N'海边的夕阳景色显得格外浪漫迷人。', N'Cảnh hoàng hôn ven biển hiện lên lãng mạn và quyến rũ khác thường.', N''),
(N'诚恳', N'chéng kěn', N'Thành khẩn', 4, N'Thái độ', N'他的态度十分诚恳，打动了所有人。', N'Thái độ của anh ấy vô cùng thành khẩn, đã làm lay động tất cả mọi người.', N''),
(N'丰富', N'fēng fù', N'Phong phú', 4, N'Tính từ', N'旅行能够丰富我们的见识与心智。', N'Những chuyến du lịch có thể làm phong phú vốn hiểu biết và tâm trí ta.', N''),
(N'复杂', N'fù zá', N'Phức tạp', 4, N'Tính chất', N'当今国际局势变幻莫测且十分复杂。', N'Cục diện quốc tế hiện nay biến đổi khôn lường và hết sức phức tạp.', N''),
(N'勇敢', N'yǒng gǎn', N'Dũng cảm', 4, N'Phẩm chất', N'消防队员勇敢地冲进火场救出群众。', N'Các chiến sĩ cứu hỏa dũng cảm lao vào biển lửa cứu thoát người dân.', N''),
(N'谦虚', N'qiān xū', N'Khiêm tốn', 4, N'Phẩm chất', N'他虽声名远扬，但为人极其谦虚谨慎。', N'Anh ấy dẫu danh tiếng vang xa, nhưng làm người cực kỳ khiêm tốn cẩn trọng.', N''),
(N'积极', N'jī jí', N'Tích cực', 4, N'Thái độ', N'以积极乐观的心态去面对生活中的起伏。', N'Dùng tâm thái tích cực lạc quan để đối diện trước những thăng trầm đời sống.', N'');
GO

-- 5. HSK 5: Thêm 25 từ chuyên ngành & thành ngữ
INSERT INTO Words (Hanzi, Pinyin, MeaningVi, HskLevel, Topic, ExampleSentence, ExampleMeaningVi, AudioUrl) VALUES
(N'胸有成竹', N'xiōng yǒu chéng zhú', N'Nắm chắc phần thắng, tự tin', 5, N'Thành ngữ', N'在登上辩论赛讲台前，他早已胸有成竹。', N'Trước khi bước lên bục thi tranh biện, anh ấy đã sớm nắm chắc phần thắng.', N''),
(N'朝三暮四', N'zhāo sān mù sì', N'Sớm ba chiều bốn, thay đổi thất thường', 5, N'Thành ngữ', N'做决策切忌朝三暮四，必须保持战略定力。', N'Ra quyết sách chớ sớm ba chiều bốn, bắt buộc phải giữ vững định lực chiến lược.', N''),
(N'守株待兔', N'shǒu zhū dài tù', N'Ôm cây đợi thỏ, thụ động', 5, N'Thành ngữ', N'时代在飞速发展，守株待兔注定会被市场淘汰。', N'Thời đại phát triển vũ bão, ôm cây đợi thỏ ắt sẽ bị thị trường đào thải.', N''),
(N'画龙点睛', N'huà lóng diǎn jīng', N'Điểm nhãn cho rồng, nét vẽ then chốt', 5, N'Thành ngữ', N'这句神来之笔的结语起到了画龙点睛的奇效。', N'Câu kết thần tình này đã phát huy kỳ tích điểm nhãn cho rồng.', N''),
(N'刻舟求剑', N'kè zhōu qiú jiàn', N'Khắc thuyền tìm kiếm, bảo thủ máy móc', 5, N'Thành ngữ', N'用老套的思想衡量新事物无异于刻舟求剑。', N'Dùng tư duy rập khuôn lỗi thời đo lường cái mới chẳng khác nào khắc thuyền tìm kiếm.', N''),
(N'闻名遐迩', N'wén míng xiá ěr', N'Tiếng tăm vang dội gần xa', 5, N'Thành ngữ', N'这家百年老字号的中药铺闻名遐迩。', N'Tiệm thuốc bắc cổ truyền trăm năm danh tiếng này tiếng tăm vang dội gần xa.', N''),
(N'自相矛盾', N'zì xiāng máo dùn', N'Tự mâu thuẫn, tiền hậu bất nhất', 5, N'Thành ngữ', N'他前后两次的供词破绽百出，自相矛盾。', N'Lời khai hai lần trước sau của anh ta đầy sơ hở, tự mâu thuẫn lẫn nhau.', N''),
(N'见利忘义', N'jiàn lì wàng yì', N'Thấy lợi quên nghĩa', 5, N'Thành ngữ', N'商人最重要的是诚信守诺，绝不能见利忘义。', N'Người kinh doanh quan trọng nhất là chữ tín, tuyệt đối chớ thấy lợi quên nghĩa.', N''),
(N'旗袍', N'qí páo', N'Áo xường xám', 5, N'Văn hóa', N'旗袍体现了东方女性独特的优雅与神韵。', N'Áo xường xám thể hiện nét thanh lịch và thần thái độc đáo của phụ nữ phương Đông.', N''),
(N'京剧', N'jīng jù', N'Kinh kịch', 5, N'Nghệ thuật', N'京剧是中国传统戏曲艺术的国粹代表。', N'Kinh kịch là đại diện quốc bảo của nghệ thuật hý kịch truyền thống Trung Hoa.', N''),
(N'茶道', N'chá dào', N'Trà đạo', 5, N'Văn hóa', N'茶道讲究心神宁静与天人合一的和美境界。', N'Trà đạo chú trọng sự an tịnh tâm hồn và cảnh giới hòa mỹ thiên nhân hợp nhất.', N''),
(N'书法', N'shū fǎ', N'Thư pháp', 5, N'Nghệ thuật', N'练习中国书法能够修身养性并陶冶情操。', N'Luyện viết thư pháp chữ Hán có thể tu thân dưỡng tính và bồi đắp tâm hồn.', N''),
(N'功夫', N'gōng fu', N'Võ thuật Kungfu', 5, N'Thể thao', N'中国功夫不仅是一种武术，更是深奥的哲学。', N'Kungfu Trung Hoa không chỉ là một môn võ thuật mà còn là triết học uyên thâm.', N''),
(N'剪纸', N'jiǎn zhǐ', N'Nghệ thuật cắt giấy', 5, N'Nghệ thuật', N'民间剪纸艺术寄托了人们对美好生活的向往。', N'Nghệ thuật cắt giấy dân gian gửi gắm ước vọng của con người về cuộc sống tốt lành.', N''),
(N'针灸', N'zhēn jiǔ', N'Châm cứu', 5, N'Y học', N'中医针灸在治疗慢性疼痛方面疗效卓越。', N'Châm cứu Đông y mang lại hiệu quả vượt trội trong điều trị các cơn đau mãn tính.', N''),
(N'太极拳', N'tài jí quán', N'Thái Cực Quyền', 5, N'Thể thao', N'清晨许多老人在公园悠闲地练习太极拳。', N'Sáng sớm nhiều bậc cao niên thong thả luyện tập Thái Cực Quyền trong công viên.', N''),
(N'风水', N'fēng shuǐ', N'Phong thủy', 5, N'Văn hóa', N'传统建筑格局中十分讲究藏风聚气的风水学。', N'Bố cục kiến trúc truyền thống rất chú trọng thuật phong thủy tàng phong tụ khí.', N''),
(N'陶瓷', N'táo cí', N'Gốm sứ', 5, N'Nghệ thuật', N'景德镇陶瓷以白如玉、明如镜而名扬海内外。', N'Gốm sứ Cảnh Đức Trấn trắng như ngọc, sáng như gương nức tiếng gần xa.', N''),
(N'丝绸', N'sī chóu', N'Tơ lụa', 5, N'Văn hóa', N'古代丝绸之路极大地促进了东西方的经贸往来。', N'Con đường Tơ Lụa cổ đại đã thúc đẩy mạnh mẽ giao thương kinh tế Đông - Tây.', N''),
(N'武术', N'wǔ shù', N'Võ thuật', 5, N'Thể thao', N'中华武术博大精深，蕴含着自强不息的民族精神。', N'Võ thuật Trung Hoa bác đại tinh thâm, hàm chứa tinh thần dân tộc tự cường bất khuất.', N''),
(N'端午节', N'duān wǔ jié', N'Tết Đoan Ngọ', 5, N'Lễ hội', N'端午节吃粽子和赛龙舟是传承千年的风俗。', N'Tết Đoan Ngọ ăn bánh ú và đua thuyền rồng là phong tục truyền tụng ngàn năm.', N''),
(N'中秋节', N'zhōng qiū jié', N'Tết Trung Thu', 5, N'Lễ hội', N'中秋佳节一家人欢聚一堂赏月品尝月饼。', N'Dịp Tết Trung Thu cả nhà quây quần sum họp ngắm trăng thưởng thức bánh trung thu.', N''),
(N'春节', N'chūn jié', N'Tết Nguyên Đán', 5, N'Lễ hội', N'春节是中国民间最隆重热闹的传统佳节。', N'Tết Nguyên Đán là ngày tết cổ truyền long trọng và náo nhiệt nhất dân gian.', N''),
(N'清明节', N'qīng míng jié', N'Tết Thanh Minh', 5, N'Lễ hội', N'清明节人们返乡扫墓祭祖并踏青郊游。', N'Tết Thanh Minh người người về quê tảo mộ viếng tổ tiên và du xuân vãn cảnh.', N''),
(N'重阳节', N'chóng yáng jié', N'Tết Trùng Cửu', 5, N'Lễ hội', N'九九重阳节是倡导尊老敬老的传统敬老节日。', N'Mùng chín tháng chín Trùng Cửu là ngày hội truyền thống tôn kính người cao tuổi.', N'');
GO

-- 6. HSK 6: Thêm 25 thành ngữ & triết học cao cấp
INSERT INTO Words (Hanzi, Pinyin, MeaningVi, HskLevel, Topic, ExampleSentence, ExampleMeaningVi, AudioUrl) VALUES
(N'安居乐业', N'ān jū lè yè', N'An cư lạc nghiệp', 6, N'Thành ngữ', N'社会安定富足，老百姓才能安居乐业。', N'Xã hội an định sung túc, bách tính mới có thể an cư lạc nghiệp.', N''),
(N'名副其实', N'míng fù qí shí', N'Danh xứng với thực, xứng danh', 6, N'Thành ngữ', N'他以卓越的战绩证明了自己是名副其实的冠军。', N'Anh ấy bằng chiến tích lẫy lừng chứng minh mình xứng danh là nhà vô địch.', N''),
(N'废寝忘食', N'fèi qǐn wàng shí', N'Quên ăn quên ngủ', 6, N'Thành ngữ', N'为了攻克这个科研难关，他废寝忘食地奋战了三个月。', N'Để vượt qua nút thắt khoa học này, anh ấy quên ăn quên ngủ phấn đấu ròng rã ba tháng.', N''),
(N'实事求是', N'shí shì qiú shì', N'Thực sự cầu thị', 6, N'Thành ngữ', N'搞学术研究必须坚持实事求是的严谨治学精神。', N'Làm nghiên cứu học thuật bắt buộc phải kiên trì tinh thần thực sự cầu thị nghiêm cẩn.', N''),
(N'精益求精', N'jīng yì qiú jīng', N'Đã tinh càng cầu tinh, không ngừng hoàn thiện', 6, N'Thành ngữ', N'大国工匠在技艺上始终秉持着精益求精的执着信念。', N'Những nghệ nhân bậc thầy luôn giữ trọn niềm tin bền bỉ không ngừng hoàn thiện tay nghề.', N''),
(N'自强不息', N'zì qiáng bù xī', N'Tự cường bất khuất', 6, N'Thành ngữ', N'天行健，君子以自强不息。', N'Trời vận hành mạnh mẽ, người quân tử noi theo mà không ngừng vươn lên tự cường.', N''),
(N'厚德载物', N'hòu dé zài wù', N'Đức dày nâng đỡ vạn vật', 6, N'Thành ngữ', N'君子当以宽厚仁德之怀，包容并涵养世间万物。', N'Bậc quân tử hãy lấy tấm lòng bao dung nhân đức dày dặn để che chở và nâng đỡ muôn loài.', N''),
(N'海纳百川', N'hǎi nà bǎi chuān', N'Biển lớn dung nạp trăm sông, độ lượng', 6, N'Thành ngữ', N'海纳百川，有容乃大；壁立千仞，无欲则刚。', N'Biển lớn dung nạp trăm sông vì có dung lượng lớn; vách đá sừng sững ngàn trượng vì không ham muốn.', N''),
(N'随机应变', N'suí jī yìng biàn', N'Tùy cơ ứng biến', 6, N'Thành ngữ', N'商场如战场，优秀的指挥者必须懂得随机应变。', N'Thương trường như chiến trường, người chỉ huy xuất sắc phải thấu hiểu thuật tùy cơ ứng biến.', N''),
(N'集思广益', N'jí sī guǎng yì', N'Tập hợp trí tuệ, gom ý kiến chung', 6, N'Thành ngữ', N'通过广泛调研和集思广益，最终确定了最优方案。', N'Thông qua khảo sát diện rộng và gom góp trí tuệ chung, phương án tối ưu đã được ấn định.', N''),
(N'举一反三', N'jǔ yī fǎn sān', N'Suy một ra ba, học một biết mười', 6, N'Thành ngữ', N'聪颖的学者不仅善于领悟，更能融会贯通、举一反三。', N'Học giả thông tuệ chẳng những giỏi lĩnh hội mà còn khéo dung hợp, suy một ra mười.', N''),
(N'同舟共济', N'tóng zhōu gòng jì', N'Cùng chung một thuyền, đồng cam cộng khổ', 6, N'Thành ngữ', N'面对全球性危机，世界各国应当休戚与共、同舟共济。', N'Trước khủng hoảng toàn cầu, các quốc gia trên thế giới nên san sẻ buồn vui, cùng chung một thuyền.', N''),
(N'风雨同舟', N'fēng yǔ tóng zhōu', N'Cùng hội cùng thuyền vượt sóng gió', 6, N'Thành ngữ', N'这对恩爱夫妻在风雨同舟中携手走过了半个世纪。', N'Đôi vợ chồng ân ái này đã cùng hội cùng thuyền nắm tay nhau đi qua nửa thế kỷ thăng trầm.', N''),
(N'竭尽全力', N'jié jìn quán lì', N'Dốc hết toàn lực', 6, N'Thành ngữ', N'医疗团队竭尽全力抢救重症患者的生命。', N'Đội ngũ y tế đã dốc hết toàn lực để giành giật lại sinh mạng cho bệnh nhân nguy kịch.', N''),
(N'络绎不绝', N'luò yì bù jué', N'Nườm nượp không ngớt', 6, N'Thành ngữ', N'前来博物馆参观珍贵文物展出的观众络绎不绝。', N'Lượng khách đến bảo tàng thưởng ngoạn triển lãm cổ vật quý nườm nượp kéo đến không ngớt.', N''),
(N'日新月异', N'rì xīn yuè yì', N'Ngày một đổi mới, thay đổi từng ngày', 6, N'Thành ngữ', N'现代信息科技日新月异，给人类社会带来深刻变革。', N'Công nghệ thông tin hiện đại ngày một đổi mới, mang lại biến chuyển sâu sắc cho xã hội.', N''),
(N'天经地义', N'tiān jīng dì yì', N'Lẽ dĩ nhiên, đạo lý hiển nhiên', 6, N'Thành ngữ', N'孝敬父母、尊师重道自古以来便是天经地义的美德。', N'Hiếu thuận song thân, tôn sư trọng đạo từ ngàn xưa vốn là đạo lý hiển nhiên tốt đẹp.', N''),
(N'美不胜收', N'měi bù shèng shōu', N'Đẹp không xuể, cảnh sắc say đắm', 6, N'Thành ngữ', N'春天的江南水乡风光如诗如画，美不胜收。', N'Cảnh sắc sông nước Giang Nam mùa xuân đẹp như thơ như họa, ngắm mãi không cùng.', N''),
(N'蔚为壮观', N'wèi wéi zhuàng guān', N'Hùng vĩ tráng lệ', 6, N'Thành ngữ', N'每年秋季钱塘江大潮奔腾咆哮，气势磅礴，蔚为壮观。', N'Mỗi độ thu về triều cường Tiền Đường Giang cuồn cuộn gầm vang, khí thế hào hùng tráng lệ.', N''),
(N'叹为观止', N'tàn wéi guān zhǐ', N'Trầm trồ thán phục, tột đỉnh nghệ thuật', 6, N'Thành ngữ', N'舞台剧精妙绝伦的高难度杂技表演令人叹为观止。', N'Màn xiếc kỹ thuật đỉnh cao tinh diệu trên sân khấu kịch khiến người xem trầm trồ thán phục.', N''),
(N'博大精深', N'bó dà jīng shēn', N'Bác đại tinh thâm, uyên bác sâu rộng', 6, N'Thành ngữ', N'数千年的中医药文化博大精深，蕴藏着无穷的智慧。', N'Nền văn hóa Đông y mấy ngàn năm bác đại tinh thâm, ẩn chứa trí tuệ vô tận.', N''),
(N'源远流长', N'yuán yuǎn liú cháng', N'Nguồn xa dòng dài, ngàn năm lưu truyền', 6, N'Thành ngữ', N'中越两国的友好交流传统源远流长。', N'Truyền thống giao lưu hữu nghị giữa hai nước Việt - Trung có nguồn xa dòng dài lâu đời.', N''),
(N'息息相关', N'xī xī xiāng guān', N'Quan hệ mật thiết, gắn bó chặt chẽ', 6, N'Thành ngữ', N'环境保护与每个人日常生活的身心福祉息息相关。', N'Bảo vệ môi trường có mối quan hệ mật thiết gắn bó mật thiết đến hạnh phúc của mỗi người.', N''),
(N'潜移默化', N'qián yí mò huà', N'Thấm nhuần dần dần', 6, N'Thành ngữ', N'优秀的名著经典总是在不知不觉中对读者产生潜移默化的熏陶。', N'Những tác phẩm kinh điển ưu tú luôn thấm nhuần tự nhiên vào tâm hồn độc giả.', N''),
(N'返璞归真', N'fǎn pú guī zhēn', N'Trở về với nguyên bản thuần khiết', 6, N'Thành ngữ', N'在繁杂喧嚣的都市奔波久了，人们越发渴望返璞归真。', N'Bôn ba nơi đô thị phồn tạp đã lâu, con người càng khao khát tìm về với sự thuần khiết nguyên sơ.', N'');
GO

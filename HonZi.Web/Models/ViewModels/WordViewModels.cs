using System.Collections.Generic;
using System.ComponentModel.DataAnnotations;
using Microsoft.AspNetCore.Http;

namespace HonZi.Web.Models.ViewModels
{
    public class WordListViewModel
    {
        public List<Word> Words { get; set; } = new();
        public int TotalCount { get; set; }
        public int CurrentPage { get; set; } = 1;
        public int PageSize { get; set; } = 15;
        public int TotalPages => (int)System.Math.Ceiling((double)TotalCount / PageSize);
        public int? SelectedHsk { get; set; }
        public string? SearchQuery { get; set; }
        public string? SelectedTopic { get; set; }
        public List<string> Topics { get; set; } = new();
    }

    public class WordFormViewModel
    {
        public int WordId { get; set; }

        [Required(ErrorMessage = "Chữ Hán không được để trống.")]
        [MaxLength(50)]
        [Display(Name = "Chữ Hán (Hanzi)")]
        public string Hanzi { get; set; } = string.Empty;

        [Required(ErrorMessage = "Phiên âm Pinyin không được để trống.")]
        [MaxLength(100)]
        [Display(Name = "Phiên âm Pinyin")]
        public string Pinyin { get; set; } = string.Empty;

        [Required(ErrorMessage = "Nghĩa tiếng Việt không được để trống.")]
        [MaxLength(255)]
        [Display(Name = "Nghĩa tiếng Việt")]
        public string MeaningVi { get; set; } = string.Empty;

        [Required(ErrorMessage = "Vui lòng chọn cấp độ HSK.")]
        [Range(1, 6, ErrorMessage = "Cấp độ HSK từ 1 đến 6.")]
        [Display(Name = "Cấp độ HSK")]
        public int HskLevel { get; set; } = 1;

        [MaxLength(100)]
        [Display(Name = "Chủ đề")]
        public string? Topic { get; set; } = "Từ vựng chung";

        [MaxLength(500)]
        [Display(Name = "Câu ví dụ minh họa")]
        public string? ExampleSentence { get; set; }

        [MaxLength(500)]
        [Display(Name = "Dịch nghĩa câu ví dụ")]
        public string? ExampleMeaningVi { get; set; }

        [MaxLength(255)]
        [Display(Name = "Đường dẫn Audio (tùy chọn)")]
        public string? AudioUrl { get; set; }
    }

    public class WordImportViewModel
    {
        [Required(ErrorMessage = "Vui lòng chọn file Excel (.xlsx) hoặc CSV để tải lên.")]
        public IFormFile? File { get; set; }
    }
}

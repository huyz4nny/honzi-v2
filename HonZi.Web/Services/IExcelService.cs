using System.Collections.Generic;
using System.IO;
using System.Threading.Tasks;
using HonZi.Web.Models;

namespace HonZi.Web.Services
{
    public class WordImportItem
    {
        public string Hanzi { get; set; } = string.Empty;
        public string Pinyin { get; set; } = string.Empty;
        public string MeaningVi { get; set; } = string.Empty;
        public int HskLevel { get; set; } = 1;
        public string? Topic { get; set; }
        public string? ExampleSentence { get; set; }
        public string? ExampleMeaningVi { get; set; }
        public string? AudioUrl { get; set; }
        public string? ErrorMessage { get; set; }
        public bool IsValid => string.IsNullOrEmpty(ErrorMessage);
    }

    public class ImportResultDto
    {
        public int TotalRows { get; set; }
        public int SuccessCount { get; set; }
        public int FailureCount { get; set; }
        public List<WordImportItem> ProcessedItems { get; set; } = new();
        public List<string> Errors { get; set; } = new();
    }

    public interface IExcelService
    {
        Task<ImportResultDto> ParseWordsFileAsync(Stream fileStream, string fileName);
        byte[] GenerateSampleExcelTemplate();
    }
}

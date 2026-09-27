using System.Collections.Generic;
using System.Threading.Tasks;
using HonZi.Web.Models;

namespace HonZi.Web.Services
{
    public interface IWordService
    {
        Task<(List<Word> Words, int TotalCount)> GetWordsAsync(int? hskLevel, string? search, string? topic, int page, int pageSize);
        Task<Word?> GetWordByIdAsync(int id);
        Task<bool> CreateWordAsync(Word word);
        Task<bool> UpdateWordAsync(Word word);
        Task<bool> DeleteWordAsync(int id);
        Task<List<string>> GetAllTopicsAsync();
        Task<List<Word>> GetWordsByHskAsync(int hskLevel);
    }
}

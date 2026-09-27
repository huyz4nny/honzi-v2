using System;
using System.Collections.Generic;
using System.Linq;
using System.Threading.Tasks;
using Microsoft.EntityFrameworkCore;
using HonZi.Web.Data;
using HonZi.Web.Models;

namespace HonZi.Web.Services
{
    public class WordService : IWordService
    {
        private readonly HanziGoDbContext _context;

        public WordService(HanziGoDbContext context)
        {
            _context = context;
        }

        public async Task<(List<Word> Words, int TotalCount)> GetWordsAsync(int? hskLevel, string? search, string? topic, int page, int pageSize)
        {
            var query = _context.Words.AsNoTracking().AsQueryable();

            if (hskLevel.HasValue && hskLevel.Value >= 1 && hskLevel.Value <= 6)
            {
                query = query.Where(w => w.HskLevel == hskLevel.Value);
            }

            if (!string.IsNullOrWhiteSpace(topic))
            {
                query = query.Where(w => w.Topic == topic);
            }

            if (!string.IsNullOrWhiteSpace(search))
            {
                var s = search.Trim();
                query = query.Where(w => w.Hanzi.Contains(s) || w.Pinyin.Contains(s) || w.MeaningVi.Contains(s));
            }

            int totalCount = await query.CountAsync();
            var words = await query
                .OrderBy(w => w.HskLevel)
                .ThenBy(w => w.WordId)
                .Skip((page - 1) * pageSize)
                .Take(pageSize)
                .ToListAsync();

            return (words, totalCount);
        }

        public async Task<Word?> GetWordByIdAsync(int id)
        {
            return await _context.Words.FindAsync(id);
        }

        public async Task<bool> CreateWordAsync(Word word)
        {
            _context.Words.Add(word);
            return await _context.SaveChangesAsync() > 0;
        }

        public async Task<bool> UpdateWordAsync(Word word)
        {
            _context.Words.Update(word);
            return await _context.SaveChangesAsync() > 0;
        }

        public async Task<bool> DeleteWordAsync(int id)
        {
            var word = await _context.Words.FindAsync(id);
            if (word == null) return false;

            _context.Words.Remove(word);
            return await _context.SaveChangesAsync() > 0;
        }

        public async Task<List<string>> GetAllTopicsAsync()
        {
            return await _context.Words
                .Where(w => !string.IsNullOrEmpty(w.Topic))
                .Select(w => w.Topic!)
                .Distinct()
                .OrderBy(t => t)
                .ToListAsync();
        }

        public async Task<List<Word>> GetWordsByHskAsync(int hskLevel)
        {
            return await _context.Words
                .AsNoTracking()
                .Where(w => w.HskLevel == hskLevel)
                .OrderBy(w => w.WordId)
                .ToListAsync();
        }
    }
}

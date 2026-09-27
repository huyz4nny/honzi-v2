using System.Collections.Generic;

namespace HonZi.Web.Models.ViewModels
{
    public class FlashcardViewModel
    {
        public int SelectedHsk { get; set; } = 1;
        public List<Word> Words { get; set; } = new();
        public int CurrentIndex { get; set; } = 0;
        public Word? CurrentWord => Words.Count > CurrentIndex ? Words[CurrentIndex] : null;
        public int TotalWords => Words.Count;
        public bool IsCompleted => Words.Count > 0 && CurrentIndex >= Words.Count;
        public bool IsSrsMode { get; set; } = false;
        public int DueCount { get; set; } = 0;
        public UserProgress? CurrentProgress { get; set; }
    }
}

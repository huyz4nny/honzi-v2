using System.Collections.Generic;
using System.ComponentModel.DataAnnotations;
using System.ComponentModel.DataAnnotations.Schema;

namespace HonZi.Web.Models
{
    [Table("Words")]
    public class Word
    {
        [Key]
        [Column("WordID")]
        public int WordId { get; set; }

        [Required]
        [MaxLength(50)]
        public string Hanzi { get; set; } = string.Empty;

        [Required]
        [MaxLength(100)]
        public string Pinyin { get; set; } = string.Empty;

        [Required]
        [MaxLength(255)]
        public string MeaningVi { get; set; } = string.Empty;

        [Required]
        [Range(1, 6)]
        public int HskLevel { get; set; } = 1;

        [MaxLength(100)]
        public string? Topic { get; set; } = "Từ vựng chung";

        [MaxLength(500)]
        public string? ExampleSentence { get; set; }

        [MaxLength(500)]
        public string? ExampleMeaningVi { get; set; }

        [MaxLength(255)]
        public string? AudioUrl { get; set; }

        // Navigation properties
        public virtual ICollection<UserProgress> UserProgresses { get; set; } = new List<UserProgress>();
    }
}

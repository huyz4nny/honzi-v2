using Microsoft.EntityFrameworkCore;
using HonZi.Web.Models;

namespace HonZi.Web.Data
{
    public class HanziGoDbContext : DbContext
    {
        public HanziGoDbContext(DbContextOptions<HanziGoDbContext> options) : base(options)
        {
        }

        public DbSet<User> Users { get; set; } = null!;
        public DbSet<Word> Words { get; set; } = null!;
        public DbSet<UserProgress> UserProgresses { get; set; } = null!;
        public DbSet<QuizResult> QuizResults { get; set; } = null!;
        public DbSet<ListeningResult> ListeningResults { get; set; } = null!;

        protected override void OnModelCreating(ModelBuilder modelBuilder)
        {
            base.OnModelCreating(modelBuilder);

            // UserProgress unique index on (UserID, WordID)
            modelBuilder.Entity<UserProgress>()
                .HasIndex(up => new { up.UserId, up.WordId })
                .IsUnique();

            modelBuilder.Entity<UserProgress>()
                .HasOne(up => up.User)
                .WithMany(u => u.UserProgresses)
                .HasForeignKey(up => up.UserId)
                .OnDelete(DeleteBehavior.Cascade);

            modelBuilder.Entity<UserProgress>()
                .HasOne(up => up.Word)
                .WithMany(w => w.UserProgresses)
                .HasForeignKey(up => up.WordId)
                .OnDelete(DeleteBehavior.Cascade);

            modelBuilder.Entity<QuizResult>()
                .HasOne(qr => qr.User)
                .WithMany(u => u.QuizResults)
                .HasForeignKey(qr => qr.UserId)
                .OnDelete(DeleteBehavior.Cascade);

            modelBuilder.Entity<ListeningResult>()
                .HasOne(lr => lr.User)
                .WithMany(u => u.ListeningResults)
                .HasForeignKey(lr => lr.UserId)
                .OnDelete(DeleteBehavior.Cascade);
        }
    }
}

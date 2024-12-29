using Microsoft.EntityFrameworkCore;
using Photon.Backend.Database.Models;
using Photon.Backend.VOs;

namespace Photon.Backend.Database;

public class PhotonContext(DbContextOptions<PhotonContext> options) : DbContext(options)
{
    public DbSet<UserEntity> Users { get; set; }

    protected override void OnModelCreating(ModelBuilder modelBuilder)
    {
        modelBuilder.Entity<UserEntity>(b =>
        {
            b.Property(u => u.Email)
                .HasVogenConversion();
            b.Property(u => u.Username)
                .HasVogenConversion();
            b.Property(u => u.Id)
                .HasVogenConversion();
            b.Property(u => u.NotificationToken)
                .HasConversion(token => token == null ? null : token.Value.Value, value => value == null ? null : NotificationToken.From(value));
            b.Property(u => u.DbId)
                .ValueGeneratedOnAdd();
        });
    }

    protected override void OnConfiguring(DbContextOptionsBuilder optionsBuilder)
    {
        var config = new ConfigurationBuilder()
            .AddJsonFile("Config.json")
            .Build();
        
        var host = config["Database:Host"];
        var port = config["Database:Port"];
        var user = config["Database:User"];
        var password = config["Database:Password"];
        var database = config["Database:Database"];
        
        optionsBuilder.UseNpgsql($"Server={host};Port={port};Database={database};Username ={user};Password={password}");
    }

}
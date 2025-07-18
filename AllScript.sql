USE [master]
GO
/****** Object:  Database [GameStore]    Script Date: 7/17/2025 7:13:32 PM ******/
CREATE DATABASE [GameStore]
 CONTAINMENT = NONE
 ON  PRIMARY 
( NAME = N'GameStore', FILENAME = N'C:\Program Files\Microsoft SQL Server\MSSQL16.SQLEXPRESS\MSSQL\DATA\GameStore.mdf' , SIZE = 8192KB , MAXSIZE = UNLIMITED, FILEGROWTH = 65536KB )
 LOG ON 
( NAME = N'GameStore_log', FILENAME = N'C:\Program Files\Microsoft SQL Server\MSSQL16.SQLEXPRESS\MSSQL\DATA\GameStore_log.ldf' , SIZE = 8192KB , MAXSIZE = 2048GB , FILEGROWTH = 65536KB )
 WITH CATALOG_COLLATION = DATABASE_DEFAULT, LEDGER = OFF
GO
ALTER DATABASE [GameStore] SET COMPATIBILITY_LEVEL = 160
GO
IF (1 = FULLTEXTSERVICEPROPERTY('IsFullTextInstalled'))
begin
EXEC [GameStore].[dbo].[sp_fulltext_database] @action = 'enable'
end
GO
ALTER DATABASE [GameStore] SET ANSI_NULL_DEFAULT OFF 
GO
ALTER DATABASE [GameStore] SET ANSI_NULLS OFF 
GO
ALTER DATABASE [GameStore] SET ANSI_PADDING OFF 
GO
ALTER DATABASE [GameStore] SET ANSI_WARNINGS OFF 
GO
ALTER DATABASE [GameStore] SET ARITHABORT OFF 
GO
ALTER DATABASE [GameStore] SET AUTO_CLOSE ON 
GO
ALTER DATABASE [GameStore] SET AUTO_SHRINK OFF 
GO
ALTER DATABASE [GameStore] SET AUTO_UPDATE_STATISTICS ON 
GO
ALTER DATABASE [GameStore] SET CURSOR_CLOSE_ON_COMMIT OFF 
GO
ALTER DATABASE [GameStore] SET CURSOR_DEFAULT  GLOBAL 
GO
ALTER DATABASE [GameStore] SET CONCAT_NULL_YIELDS_NULL OFF 
GO
ALTER DATABASE [GameStore] SET NUMERIC_ROUNDABORT OFF 
GO
ALTER DATABASE [GameStore] SET QUOTED_IDENTIFIER OFF 
GO
ALTER DATABASE [GameStore] SET RECURSIVE_TRIGGERS OFF 
GO
ALTER DATABASE [GameStore] SET  ENABLE_BROKER 
GO
ALTER DATABASE [GameStore] SET AUTO_UPDATE_STATISTICS_ASYNC OFF 
GO
ALTER DATABASE [GameStore] SET DATE_CORRELATION_OPTIMIZATION OFF 
GO
ALTER DATABASE [GameStore] SET TRUSTWORTHY OFF 
GO
ALTER DATABASE [GameStore] SET ALLOW_SNAPSHOT_ISOLATION OFF 
GO
ALTER DATABASE [GameStore] SET PARAMETERIZATION SIMPLE 
GO
ALTER DATABASE [GameStore] SET READ_COMMITTED_SNAPSHOT OFF 
GO
ALTER DATABASE [GameStore] SET HONOR_BROKER_PRIORITY OFF 
GO
ALTER DATABASE [GameStore] SET RECOVERY SIMPLE 
GO
ALTER DATABASE [GameStore] SET  MULTI_USER 
GO
ALTER DATABASE [GameStore] SET PAGE_VERIFY CHECKSUM  
GO
ALTER DATABASE [GameStore] SET DB_CHAINING OFF 
GO
ALTER DATABASE [GameStore] SET FILESTREAM( NON_TRANSACTED_ACCESS = OFF ) 
GO
ALTER DATABASE [GameStore] SET TARGET_RECOVERY_TIME = 60 SECONDS 
GO
ALTER DATABASE [GameStore] SET DELAYED_DURABILITY = DISABLED 
GO
ALTER DATABASE [GameStore] SET ACCELERATED_DATABASE_RECOVERY = OFF  
GO
ALTER DATABASE [GameStore] SET QUERY_STORE = ON
GO
ALTER DATABASE [GameStore] SET QUERY_STORE (OPERATION_MODE = READ_WRITE, CLEANUP_POLICY = (STALE_QUERY_THRESHOLD_DAYS = 30), DATA_FLUSH_INTERVAL_SECONDS = 900, INTERVAL_LENGTH_MINUTES = 60, MAX_STORAGE_SIZE_MB = 1000, QUERY_CAPTURE_MODE = AUTO, SIZE_BASED_CLEANUP_MODE = AUTO, MAX_PLANS_PER_QUERY = 200, WAIT_STATS_CAPTURE_MODE = ON)
GO
USE [GameStore]
GO
/****** Object:  UserDefinedFunction [dbo].[NumberOfCommentsForAllCompanyPosts]    Script Date: 7/17/2025 7:13:33 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE FUNCTION [dbo].[NumberOfCommentsForAllCompanyPosts](@CompanyId INT)
RETURNS INT
AS
BEGIN
    DECLARE @CommentCount INT;

    SELECT @CommentCount = COUNT(*)
    FROM CompanyPosts cp
    JOIN PostComments pc ON cp.Id = pc.PostId
    WHERE cp.CompanyId = @CompanyId;

    RETURN @CommentCount;
END
GO
/****** Object:  UserDefinedFunction [dbo].[NumberOfDisLikesForAllCompanyPosts]    Script Date: 7/17/2025 7:13:33 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE FUNCTION [dbo].[NumberOfDisLikesForAllCompanyPosts](@CompanyId INT)
RETURNS INT
AS
BEGIN
    DECLARE @LikeCount INT;

    SELECT @LikeCount = ISNULL(SUM(CASE WHEN pr.IsLiked = 0 THEN 1 ELSE 0 END), 0)
    FROM CompanyPosts cp
    JOIN PostReactions pr ON cp.Id = pr.PostId
    WHERE cp.CompanyId = @CompanyId;

    RETURN @LikeCount;
END
GO
/****** Object:  UserDefinedFunction [dbo].[NumberOfFollowersForCompany]    Script Date: 7/17/2025 7:13:33 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE FUNCTION [dbo].[NumberOfFollowersForCompany](@CompanyId INT)
RETURNS INT
AS
BEGIN
    DECLARE @FollowerCount INT;

    SELECT @FollowerCount = count(*)
    FROM Companies c
    JOIN Followers f ON c.Id = f.CompanyId
    WHERE c.Id = @CompanyId;

    RETURN @FollowerCount;
END
GO
/****** Object:  UserDefinedFunction [dbo].[NumberOfLikesForAllCompanyPosts]    Script Date: 7/17/2025 7:13:33 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE FUNCTION [dbo].[NumberOfLikesForAllCompanyPosts](@CompanyId INT)
RETURNS INT
AS
BEGIN
    DECLARE @LikeCount INT;

    SELECT @LikeCount = ISNULL(SUM(CASE WHEN pr.IsLiked = 1 THEN 1 ELSE 0 END), 0)
    FROM CompanyPosts cp
    JOIN PostReactions pr ON cp.Id = pr.PostId
    WHERE cp.CompanyId = @CompanyId;

    RETURN @LikeCount;
END
GO
/****** Object:  Table [dbo].[GameRatings]    Script Date: 7/17/2025 7:13:33 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[GameRatings](
	[UserId] [int] NOT NULL,
	[GameId] [int] NOT NULL,
	[Rate] [int] NOT NULL,
	[RatedAt] [datetime] NOT NULL,
PRIMARY KEY CLUSTERED 
(
	[UserId] ASC,
	[GameId] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[Games]    Script Date: 7/17/2025 7:13:33 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[Games](
	[Id] [int] IDENTITY(1,1) NOT NULL,
	[Name] [varchar](30) NOT NULL,
	[Price] [decimal](8, 2) NULL,
	[Description] [varchar](max) NOT NULL,
	[CategoryId] [int] NOT NULL,
	[CompanyId] [int] NOT NULL,
	[ReleaseDate] [datetime] NOT NULL,
	[UpdatedAt] [datetime] NULL,
	[Status] [varchar](15) NULL,
PRIMARY KEY CLUSTERED 
(
	[Id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY],
UNIQUE NONCLUSTERED 
(
	[Name] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]
GO
/****** Object:  View [dbo].[TotalRatingForGame]    Script Date: 7/17/2025 7:13:33 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
create view [dbo].[TotalRatingForGame]
as
select g.Id,g.[Name], avg(gr.Rate) as AverageRating
from GameRatings gr
join Games g
on gr.GameId = g.Id
group by g.[Name], g.Id
GO
/****** Object:  Table [dbo].[GameRequirements]    Script Date: 7/17/2025 7:13:33 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[GameRequirements](
	[GameId] [int] NOT NULL,
	[OS] [varchar](100) NOT NULL,
	[Processor] [varchar](100) NOT NULL,
	[RAM] [varchar](100) NOT NULL,
	[Graphics] [varchar](100) NOT NULL,
	[Storage] [varchar](20) NOT NULL,
	[IsOnline] [bit] NOT NULL,
	[Notes] [varchar](max) NULL
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]
GO
/****** Object:  Table [dbo].[Categories]    Script Date: 7/17/2025 7:13:33 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[Categories](
	[Id] [int] IDENTITY(1,1) NOT NULL,
	[Name] [varchar](100) NULL,
PRIMARY KEY CLUSTERED 
(
	[Id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  View [dbo].[GameInfo]    Script Date: 7/17/2025 7:13:33 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
create view [dbo].[GameInfo]
as
select 
g.Id,g.[Name] as GameName,g.Price,g.ReleaseDate,
c.[Name] as CategoryName,
gr.OS,gr.Graphics,gr.IsOnline,gr.Processor,gr.RAM,gr.Storage,gr.Notes
from Games g
join Categories c on g.CategoryId = c.Id
join GameRequirements gr on g.Id = gr.GameId
GO
/****** Object:  Table [dbo].[CompanyPosts]    Script Date: 7/17/2025 7:13:33 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[CompanyPosts](
	[Id] [int] IDENTITY(1,1) NOT NULL,
	[CompanyId] [int] NOT NULL,
	[IsImagePost] [bit] NOT NULL,
	[ImagePath] [varchar](max) NULL,
	[PostContent] [varchar](max) NULL,
	[Status] [varchar](10) NULL,
	[CreatedAt] [datetime] NOT NULL,
	[PublishedAt] [datetime] NULL,
PRIMARY KEY CLUSTERED 
(
	[Id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]
GO
/****** Object:  Table [dbo].[PostReactions]    Script Date: 7/17/2025 7:13:33 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[PostReactions](
	[UserId] [int] NOT NULL,
	[PostId] [int] NOT NULL,
	[IsLiked] [bit] NOT NULL,
PRIMARY KEY CLUSTERED 
(
	[UserId] ASC,
	[PostId] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  View [dbo].[TotalPostReactions]    Script Date: 7/17/2025 7:13:33 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
create view [dbo].[TotalPostReactions]
as
select cp.Id, 
sum(case when pr.IsLiked = 1 then 1 else 0 end) as likes, 
sum(case when pr.IsLiked = 0 then 1 else 0 end) as dislikes
from CompanyPosts cp
join PostReactions pr on cp.Id = pr.PostId
group by cp.id
GO
/****** Object:  Table [dbo].[Users]    Script Date: 7/17/2025 7:13:33 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[Users](
	[Id] [int] IDENTITY(1,1) NOT NULL,
	[UserName] [varchar](60) NOT NULL,
	[ImagePath] [varchar](max) NULL,
	[Email] [varchar](60) NOT NULL,
	[HashedPassword] [varchar](max) NOT NULL,
	[Phone] [varchar](20) NULL,
	[EmailConfirmation] [bit] NULL,
	[PhoneConfirmation] [bit] NULL,
	[Status] [varchar](6) NULL,
	[RoleId] [int] NOT NULL,
	[CreatedAt] [datetime] NOT NULL,
PRIMARY KEY CLUSTERED 
(
	[Id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY],
UNIQUE NONCLUSTERED 
(
	[Phone] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY],
UNIQUE NONCLUSTERED 
(
	[Email] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]
GO
/****** Object:  Table [dbo].[Companies]    Script Date: 7/17/2025 7:13:33 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[Companies](
	[Id] [int] IDENTITY(1,1) NOT NULL,
	[Name] [varchar](50) NOT NULL,
	[Email] [varchar](50) NOT NULL,
	[HashedPassword] [varchar](max) NOT NULL,
	[Country] [varchar](30) NOT NULL,
	[Address] [varchar](max) NOT NULL,
	[ImagePath] [varchar](max) NULL,
	[CreatedAt] [date] NOT NULL,
	[AccountStatus] [varchar](10) NOT NULL,
PRIMARY KEY CLUSTERED 
(
	[Id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY],
UNIQUE NONCLUSTERED 
(
	[Name] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY],
UNIQUE NONCLUSTERED 
(
	[Email] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]
GO
/****** Object:  Table [dbo].[Followers]    Script Date: 7/17/2025 7:13:33 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[Followers](
	[UserId] [int] NOT NULL,
	[CompanyId] [int] NOT NULL,
PRIMARY KEY CLUSTERED 
(
	[UserId] ASC,
	[CompanyId] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  View [dbo].[CompanyFollowers]    Script Date: 7/17/2025 7:13:33 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
create view [dbo].[CompanyFollowers]
as
select 
c.[Name] as CompanyName,
u.UserName
from Companies c
join Followers f on c.Id = f.CompanyId
join Users u on f.UserId = u.Id
GO
/****** Object:  View [dbo].[NumberOfCompanyFollowers]    Script Date: 7/17/2025 7:13:33 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
create view [dbo].[NumberOfCompanyFollowers]
as
select 
c.[Name] as CompanyName,
count(*) as NumberOfFollowers
from Companies c
join Followers f on c.Id = f.CompanyId
join Users u on f.UserId = u.Id
group by c.[Name]
GO
/****** Object:  View [dbo].[NumberOfCompanyGames]    Script Date: 7/17/2025 7:13:33 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
create view [dbo].[NumberOfCompanyGames]
as
select 
c.[Name] as CompanyName,
count(*) as NumberOfGames
from Companies c
join Games g on c.Id = g.CompanyId
where g.[Status] = 'available'
group by c.[Name]
GO
/****** Object:  View [dbo].[CompanyGames]    Script Date: 7/17/2025 7:13:33 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
create view [dbo].[CompanyGames]
as
select 
c.[Name] as CompanyName,
g.[Name],g.[Description]
from Companies c
join Games g on c.Id = g.CompanyId
where g.[Status] = 'available'
GO
/****** Object:  View [dbo].[NumberOFGamesPerCategory]    Script Date: 7/17/2025 7:13:33 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
create view [dbo].[NumberOFGamesPerCategory]
as
select 
c.[Name] as CategoryName,
count(*) as NumberOfGames
from Categories c
join Games g on c.Id = g.CategoryId
group by c.[Name]
GO
/****** Object:  View [dbo].[CompanyStatistics]    Script Date: 7/17/2025 7:13:33 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
create view [dbo].[CompanyStatistics]
as
select 
c.[Name] as CompanyName,
dbo.NumberOfFollowersForCompany(c.Id) as NumberOfFollowers,
count(distinct g.Id) as NumberOfGames,
count(distinct cp.Id) as NumberOfPosts,
dbo.NumberOfCommentsForAllCompanyPosts(c.Id) as TotalNumberOfComments,
dbo.NumberOfLikesForAllCompanyPosts(c.Id) as TotalNumberOfLikes,
dbo.NumberOfDisLikesForAllCompanyPosts(c.Id) as TotalNumberOfDisLikes 
from Companies c
left join Games g on c.Id = g.CompanyId
left join CompanyPosts cp on c.Id = cp.CompanyId
where c.AccountStatus = 'active'
group by c.Id, c.[Name]
GO
/****** Object:  Table [dbo].[BannedUsers]    Script Date: 7/17/2025 7:13:33 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[BannedUsers](
	[UserId] [int] NOT NULL,
	[Reason] [varchar](max) NOT NULL,
	[BannedAt] [date] NULL,
	[DurationDays] [int] NOT NULL,
	[BannedEndAt]  AS (CONVERT([date],dateadd(day,[DurationDays],[BannedAt])))
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]
GO
/****** Object:  Table [dbo].[Chats]    Script Date: 7/17/2025 7:13:33 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[Chats](
	[SenderId] [int] NOT NULL,
	[ReceiverId] [int] NOT NULL,
	[SentAt] [datetime] NOT NULL,
	[SeenAt] [datetime] NULL,
	[MessageContent] [nvarchar](max) NOT NULL
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]
GO
/****** Object:  Table [dbo].[Donations]    Script Date: 7/17/2025 7:13:33 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[Donations](
	[UserId] [int] NOT NULL,
	[CompanyId] [int] NOT NULL,
	[Amount] [decimal](18, 2) NOT NULL
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[FAQs]    Script Date: 7/17/2025 7:13:33 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[FAQs](
	[Question] [varchar](max) NOT NULL,
	[Answer] [varchar](max) NOT NULL
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]
GO
/****** Object:  Table [dbo].[Favourites]    Script Date: 7/17/2025 7:13:33 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[Favourites](
	[UserId] [int] NOT NULL,
	[GameId] [int] NOT NULL,
PRIMARY KEY CLUSTERED 
(
	[UserId] ASC,
	[GameId] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[Friends]    Script Date: 7/17/2025 7:13:33 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[Friends](
	[RequesterId] [int] NOT NULL,
	[ReceiverId] [int] NOT NULL,
	[Status] [varchar](10) NULL,
	[RequestedAt] [datetime] NOT NULL,
	[RespondedAt] [datetime] NULL,
PRIMARY KEY CLUSTERED 
(
	[RequesterId] ASC,
	[ReceiverId] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[GameImages]    Script Date: 7/17/2025 7:13:33 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[GameImages](
	[GameId] [int] NOT NULL,
	[ImagePath] [varchar](max) NULL,
	[IsThumbnail] [bit] NOT NULL
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]
GO
/****** Object:  Table [dbo].[GameReports]    Script Date: 7/17/2025 7:13:33 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[GameReports](
	[UserId] [int] NOT NULL,
	[GameId] [int] NOT NULL,
	[ReportMessage] [varchar](max) NOT NULL,
	[ReportedAt] [datetime] NOT NULL
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]
GO
/****** Object:  Table [dbo].[GameReviews]    Script Date: 7/17/2025 7:13:33 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[GameReviews](
	[UserId] [int] NOT NULL,
	[GameId] [int] NOT NULL,
	[CommentContent] [varchar](max) NOT NULL,
	[CreatedAt] [datetime] NOT NULL
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]
GO
/****** Object:  Table [dbo].[Gifts]    Script Date: 7/17/2025 7:13:33 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[Gifts](
	[SenderId] [int] NOT NULL,
	[ReceiverId] [int] NOT NULL,
	[GameId] [int] NOT NULL,
	[MessageContent] [varchar](max) NULL,
	[SentAt] [datetime] NOT NULL,
PRIMARY KEY CLUSTERED 
(
	[SenderId] ASC,
	[ReceiverId] ASC,
	[GameId] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]
GO
/****** Object:  Table [dbo].[Histories]    Script Date: 7/17/2025 7:13:33 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[Histories](
	[UserId] [int] NOT NULL,
	[HistoryContent] [varchar](max) NOT NULL,
	[CreatedAt] [datetime] NOT NULL
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]
GO
/****** Object:  Table [dbo].[Notifications]    Script Date: 7/17/2025 7:13:33 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[Notifications](
	[UserId] [int] NOT NULL,
	[NotificationType] [varchar](50) NOT NULL,
	[NotificationContent] [varchar](max) NOT NULL,
	[SentAt] [datetime] NOT NULL,
	[SeenAt] [datetime] NULL
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]
GO
/****** Object:  Table [dbo].[OrderItems]    Script Date: 7/17/2025 7:13:33 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[OrderItems](
	[OrderId] [int] NOT NULL,
	[GameId] [int] NOT NULL,
	[Price] [decimal](8, 2) NOT NULL,
	[IsVipUser] [bit] NOT NULL,
	[Discount] [decimal](8, 2) NOT NULL,
PRIMARY KEY CLUSTERED 
(
	[OrderId] ASC,
	[GameId] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[Orders]    Script Date: 7/17/2025 7:13:33 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[Orders](
	[Id] [int] IDENTITY(1,1) NOT NULL,
	[UserId] [int] NOT NULL,
	[CreatedAt] [datetime] NOT NULL,
PRIMARY KEY CLUSTERED 
(
	[Id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[PostComments]    Script Date: 7/17/2025 7:13:33 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[PostComments](
	[UserId] [int] NOT NULL,
	[PostId] [int] NOT NULL,
	[CommentContent] [varchar](max) NOT NULL
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]
GO
/****** Object:  Table [dbo].[Roles]    Script Date: 7/17/2025 7:13:33 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[Roles](
	[Id] [int] IDENTITY(1,1) NOT NULL,
	[RoleName] [varchar](30) NOT NULL,
PRIMARY KEY CLUSTERED 
(
	[Id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[SearchHistory]    Script Date: 7/17/2025 7:13:33 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[SearchHistory](
	[UserId] [int] NOT NULL,
	[SearchContent] [varchar](max) NOT NULL
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]
GO
/****** Object:  Table [dbo].[SupportChats]    Script Date: 7/17/2025 7:13:33 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[SupportChats](
	[UserId] [int] NOT NULL,
	[SupportId] [int] NOT NULL,
	[SentAt] [datetime] NOT NULL,
	[SeenAt] [datetime] NULL,
	[RespondAt] [datetime] NULL,
	[MessageContent] [nvarchar](max) NOT NULL,
	[RespondContent] [nvarchar](max) NULL
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]
GO
/****** Object:  Table [dbo].[UserGames]    Script Date: 7/17/2025 7:13:33 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[UserGames](
	[UserId] [int] NOT NULL,
	[GameId] [int] NOT NULL,
PRIMARY KEY CLUSTERED 
(
	[UserId] ASC,
	[GameId] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[UserReports]    Script Date: 7/17/2025 7:13:33 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[UserReports](
	[ReporterId] [int] NOT NULL,
	[ReportedUserId] [int] NOT NULL,
	[ReportMessage] [varchar](max) NOT NULL,
	[ReportedAt] [datetime] NOT NULL
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]
GO
/****** Object:  Table [dbo].[WishLists]    Script Date: 7/17/2025 7:13:33 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[WishLists](
	[UserId] [int] NOT NULL,
	[GameId] [int] NOT NULL,
PRIMARY KEY CLUSTERED 
(
	[UserId] ASC,
	[GameId] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
ALTER TABLE [dbo].[BannedUsers] ADD  DEFAULT (CONVERT([date],getdate())) FOR [BannedAt]
GO
ALTER TABLE [dbo].[Chats] ADD  DEFAULT (getdate()) FOR [SentAt]
GO
ALTER TABLE [dbo].[Companies] ADD  DEFAULT (CONVERT([date],getdate())) FOR [CreatedAt]
GO
ALTER TABLE [dbo].[CompanyPosts] ADD  DEFAULT ((0)) FOR [IsImagePost]
GO
ALTER TABLE [dbo].[CompanyPosts] ADD  DEFAULT (getdate()) FOR [CreatedAt]
GO
ALTER TABLE [dbo].[Friends] ADD  DEFAULT (getdate()) FOR [RequestedAt]
GO
ALTER TABLE [dbo].[GameImages] ADD  DEFAULT ((0)) FOR [IsThumbnail]
GO
ALTER TABLE [dbo].[GameRatings] ADD  DEFAULT (getdate()) FOR [RatedAt]
GO
ALTER TABLE [dbo].[GameReports] ADD  DEFAULT (getdate()) FOR [ReportedAt]
GO
ALTER TABLE [dbo].[GameReviews] ADD  DEFAULT (getdate()) FOR [CreatedAt]
GO
ALTER TABLE [dbo].[Games] ADD  DEFAULT (getdate()) FOR [ReleaseDate]
GO
ALTER TABLE [dbo].[Gifts] ADD  DEFAULT (getdate()) FOR [SentAt]
GO
ALTER TABLE [dbo].[Histories] ADD  DEFAULT (getdate()) FOR [CreatedAt]
GO
ALTER TABLE [dbo].[Notifications] ADD  DEFAULT (getdate()) FOR [SentAt]
GO
ALTER TABLE [dbo].[OrderItems] ADD  DEFAULT ((0)) FOR [IsVipUser]
GO
ALTER TABLE [dbo].[Orders] ADD  DEFAULT (getdate()) FOR [CreatedAt]
GO
ALTER TABLE [dbo].[SupportChats] ADD  DEFAULT (getdate()) FOR [SentAt]
GO
ALTER TABLE [dbo].[UserReports] ADD  DEFAULT (getdate()) FOR [ReportedAt]
GO
ALTER TABLE [dbo].[Users] ADD  DEFAULT ((0)) FOR [EmailConfirmation]
GO
ALTER TABLE [dbo].[Users] ADD  DEFAULT ((0)) FOR [PhoneConfirmation]
GO
ALTER TABLE [dbo].[Users] ADD  DEFAULT (getdate()) FOR [CreatedAt]
GO
ALTER TABLE [dbo].[BannedUsers]  WITH CHECK ADD FOREIGN KEY([UserId])
REFERENCES [dbo].[Users] ([Id])
GO
ALTER TABLE [dbo].[Chats]  WITH CHECK ADD FOREIGN KEY([ReceiverId])
REFERENCES [dbo].[Users] ([Id])
GO
ALTER TABLE [dbo].[Chats]  WITH CHECK ADD FOREIGN KEY([SenderId])
REFERENCES [dbo].[Users] ([Id])
GO
ALTER TABLE [dbo].[CompanyPosts]  WITH CHECK ADD FOREIGN KEY([CompanyId])
REFERENCES [dbo].[Companies] ([Id])
GO
ALTER TABLE [dbo].[Donations]  WITH CHECK ADD FOREIGN KEY([CompanyId])
REFERENCES [dbo].[Companies] ([Id])
GO
ALTER TABLE [dbo].[Donations]  WITH CHECK ADD FOREIGN KEY([UserId])
REFERENCES [dbo].[Users] ([Id])
GO
ALTER TABLE [dbo].[Favourites]  WITH CHECK ADD FOREIGN KEY([GameId])
REFERENCES [dbo].[Games] ([Id])
GO
ALTER TABLE [dbo].[Favourites]  WITH CHECK ADD FOREIGN KEY([UserId])
REFERENCES [dbo].[Users] ([Id])
GO
ALTER TABLE [dbo].[Followers]  WITH CHECK ADD FOREIGN KEY([CompanyId])
REFERENCES [dbo].[Companies] ([Id])
GO
ALTER TABLE [dbo].[Followers]  WITH CHECK ADD FOREIGN KEY([UserId])
REFERENCES [dbo].[Users] ([Id])
GO
ALTER TABLE [dbo].[Friends]  WITH CHECK ADD FOREIGN KEY([ReceiverId])
REFERENCES [dbo].[Users] ([Id])
GO
ALTER TABLE [dbo].[Friends]  WITH CHECK ADD FOREIGN KEY([RequesterId])
REFERENCES [dbo].[Users] ([Id])
GO
ALTER TABLE [dbo].[GameImages]  WITH CHECK ADD FOREIGN KEY([GameId])
REFERENCES [dbo].[Games] ([Id])
GO
ALTER TABLE [dbo].[GameRatings]  WITH CHECK ADD FOREIGN KEY([GameId])
REFERENCES [dbo].[Games] ([Id])
GO
ALTER TABLE [dbo].[GameRatings]  WITH CHECK ADD FOREIGN KEY([UserId])
REFERENCES [dbo].[Users] ([Id])
GO
ALTER TABLE [dbo].[GameReports]  WITH CHECK ADD FOREIGN KEY([GameId])
REFERENCES [dbo].[Games] ([Id])
GO
ALTER TABLE [dbo].[GameReports]  WITH CHECK ADD FOREIGN KEY([UserId])
REFERENCES [dbo].[Users] ([Id])
GO
ALTER TABLE [dbo].[GameRequirements]  WITH CHECK ADD FOREIGN KEY([GameId])
REFERENCES [dbo].[Games] ([Id])
GO
ALTER TABLE [dbo].[GameReviews]  WITH CHECK ADD FOREIGN KEY([GameId])
REFERENCES [dbo].[Games] ([Id])
GO
ALTER TABLE [dbo].[GameReviews]  WITH CHECK ADD FOREIGN KEY([UserId])
REFERENCES [dbo].[Users] ([Id])
GO
ALTER TABLE [dbo].[Games]  WITH CHECK ADD FOREIGN KEY([CompanyId])
REFERENCES [dbo].[Companies] ([Id])
GO
ALTER TABLE [dbo].[Games]  WITH CHECK ADD FOREIGN KEY([CategoryId])
REFERENCES [dbo].[Categories] ([Id])
GO
ALTER TABLE [dbo].[Gifts]  WITH CHECK ADD FOREIGN KEY([GameId])
REFERENCES [dbo].[Games] ([Id])
GO
ALTER TABLE [dbo].[Gifts]  WITH CHECK ADD FOREIGN KEY([ReceiverId])
REFERENCES [dbo].[Users] ([Id])
GO
ALTER TABLE [dbo].[Gifts]  WITH CHECK ADD FOREIGN KEY([SenderId])
REFERENCES [dbo].[Users] ([Id])
GO
ALTER TABLE [dbo].[Histories]  WITH CHECK ADD FOREIGN KEY([UserId])
REFERENCES [dbo].[Users] ([Id])
GO
ALTER TABLE [dbo].[Notifications]  WITH CHECK ADD FOREIGN KEY([UserId])
REFERENCES [dbo].[Users] ([Id])
GO
ALTER TABLE [dbo].[OrderItems]  WITH CHECK ADD FOREIGN KEY([GameId])
REFERENCES [dbo].[Games] ([Id])
GO
ALTER TABLE [dbo].[OrderItems]  WITH CHECK ADD FOREIGN KEY([OrderId])
REFERENCES [dbo].[Orders] ([Id])
GO
ALTER TABLE [dbo].[Orders]  WITH CHECK ADD FOREIGN KEY([UserId])
REFERENCES [dbo].[Users] ([Id])
GO
ALTER TABLE [dbo].[PostComments]  WITH CHECK ADD FOREIGN KEY([PostId])
REFERENCES [dbo].[CompanyPosts] ([Id])
GO
ALTER TABLE [dbo].[PostComments]  WITH CHECK ADD FOREIGN KEY([UserId])
REFERENCES [dbo].[Users] ([Id])
GO
ALTER TABLE [dbo].[PostReactions]  WITH CHECK ADD FOREIGN KEY([PostId])
REFERENCES [dbo].[CompanyPosts] ([Id])
GO
ALTER TABLE [dbo].[PostReactions]  WITH CHECK ADD FOREIGN KEY([UserId])
REFERENCES [dbo].[Users] ([Id])
GO
ALTER TABLE [dbo].[SearchHistory]  WITH CHECK ADD FOREIGN KEY([UserId])
REFERENCES [dbo].[Users] ([Id])
GO
ALTER TABLE [dbo].[SupportChats]  WITH CHECK ADD FOREIGN KEY([SupportId])
REFERENCES [dbo].[Users] ([Id])
GO
ALTER TABLE [dbo].[SupportChats]  WITH CHECK ADD FOREIGN KEY([UserId])
REFERENCES [dbo].[Users] ([Id])
GO
ALTER TABLE [dbo].[UserGames]  WITH CHECK ADD FOREIGN KEY([GameId])
REFERENCES [dbo].[Games] ([Id])
GO
ALTER TABLE [dbo].[UserGames]  WITH CHECK ADD FOREIGN KEY([UserId])
REFERENCES [dbo].[Users] ([Id])
GO
ALTER TABLE [dbo].[UserReports]  WITH CHECK ADD FOREIGN KEY([ReporterId])
REFERENCES [dbo].[Users] ([Id])
GO
ALTER TABLE [dbo].[UserReports]  WITH CHECK ADD FOREIGN KEY([ReportedUserId])
REFERENCES [dbo].[Users] ([Id])
GO
ALTER TABLE [dbo].[Users]  WITH CHECK ADD FOREIGN KEY([RoleId])
REFERENCES [dbo].[Roles] ([Id])
GO
ALTER TABLE [dbo].[WishLists]  WITH CHECK ADD FOREIGN KEY([GameId])
REFERENCES [dbo].[Games] ([Id])
GO
ALTER TABLE [dbo].[WishLists]  WITH CHECK ADD FOREIGN KEY([UserId])
REFERENCES [dbo].[Users] ([Id])
GO
ALTER TABLE [dbo].[Companies]  WITH CHECK ADD CHECK  (([AccountStatus]='decline' OR [AccountStatus]='pending' OR [AccountStatus]='active'))
GO
ALTER TABLE [dbo].[CompanyPosts]  WITH CHECK ADD CHECK  (([Status]='decline' OR [Status]='pending' OR [Status]='accepted'))
GO
ALTER TABLE [dbo].[Friends]  WITH CHECK ADD CHECK  (([Status]='declined' OR [Status]='pending' OR [Status]='accepted'))
GO
ALTER TABLE [dbo].[GameRatings]  WITH CHECK ADD CHECK  (([Rate]>=(1) AND [Rate]<=(5)))
GO
ALTER TABLE [dbo].[Games]  WITH CHECK ADD CHECK  (([Status]='decline' OR [Status]='pending' OR [Status]='available'))
GO
ALTER TABLE [dbo].[Users]  WITH CHECK ADD CHECK  (([Status]='banned' OR [Status]='active'))
GO
/****** Object:  StoredProcedure [dbo].[Show_Table]    Script Date: 7/17/2025 7:13:33 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[Show_Table]
    @TableName VARCHAR(30) = 'Users'
AS
BEGIN
    DECLARE @SQL NVARCHAR(MAX);

    BEGIN TRY
        SET @SQL = N'SELECT * FROM ' + QUOTENAME(@TableName);
        EXEC sp_executesql @SQL;
    END TRY
    BEGIN CATCH
        PRINT 'this table does not exist';
        PRINT ERROR_MESSAGE();
    END CATCH
END;
GO
USE [master]
GO
ALTER DATABASE [GameStore] SET  READ_WRITE 
GO

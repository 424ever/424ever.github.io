import { readFileSync, writeFileSync } from "fs";

if (process.argv.length != 4) {
  console.error("invalid arguments", process.argv);
  process.exit(1);
}

const base_url = "https://osu.ppy.sh/api/v2/";
const access_token = process.argv[2];
const file_path = process.argv[3];

const delay = (ms) => new Promise((resolve) => setTimeout(resolve, ms));

const get_or_die = async (path, api_version) => {
  const url = base_url + path;
  try {
    const response = await fetch(url, {
      headers: {
        "Content-Type": "application/json",
        Accept: "application/json",
        Authorization: `Bearer ${access_token}`,
        "x-api-version": api_version,
      },
    });
    if (!response.ok) {
      throw new Error(`bad response status ${response.status}`);
    }
    return response.json();
  } catch (error) {
    console.error(`failed to get ${url}: ${error}`);
    process.exit(1);
  }
};

let days;
try {
  days = JSON.parse(readFileSync(file_path));
} catch (error) {
  console.error(`failed to read ${file_path}: ${error}`);
  process.exit(1);
}

const oneday = 24 * 60 * 60 * 1000;
const today = new Date();
const rooms = await get_or_die(
  "rooms?" +
    new URLSearchParams({
      category: "daily_challenge",
      mode: "participated",
      limit: "10",
    }),
  20240529,
);
for (const room of rooms) {
  const date = new Date(room.starts_at.split("T")[0]);
  const days_diff = Math.floor((today - date) / oneday);
  const date_str = date.toISOString().split("T")[0];
  if (
    !days[date_str] ||
    days_diff <= 3 /* always consider the last few days */
  ) {
    await delay(2000); /* for rate limit */
    const room_detail = await get_or_die(`rooms/${room.id}`, 20240529);
    const beatmap = room_detail.playlist[0].beatmap;
    days[date_str] = {
      date: date_str,
      beatmap: beatmap.id,
      artist: beatmap.beatmapset.artist,
      title: beatmap.beatmapset.title,
      mapper: beatmap.beatmapset.creator,
      difficulty: beatmap.version,
      score: room_detail.current_user_score.total_score.toLocaleString("en-US"),
      accuracy: room_detail.current_user_score.accuracy.toLocaleString(
        "en-US",
        {
          style: "percent",
          minimumFractionDigits: 2,
          maximumFractionDigits: 2,
        },
      ),
    };
  }
}

try {
  writeFileSync(file_path, JSON.stringify(days, null, 2));
} catch (error) {
  console.error(`failed to write ${file_path}: ${error}`);
  process.exit(1);
}

cat >> _build/osu-daily.html << EOF
<!doctype html>
<html lang="en">
  <head>
    <meta charset="utf-8" />
    <meta name="viewport" content="width=device-width, initial-scale=1" />
    <title>osu! daily challenges</title>
    <meta name="description" content="osu! daily challenges" />

    <link rel="stylesheet" href="css/pico.colors.min.css" />
    <link rel="stylesheet" href="css/pico.min.css" />
  </head>

  <body>
    <header class="container">
      <hgroup>
        <h1>osu! daily challenges</h1>
      </hgroup>
      <nav>
        <ul>
          <li><a href="index.html">home</a></li>
          <li>
            <a href="socials.html">socials</a>
          </li>
          <li>
            <a href="osu-daily.html" aria-current="page"
              >osu! daily challenges</a
            >
          </li>
        </ul>
      </nav>
    </header>

    <main class="container">
      <table class="striped">
        <thead data-theme="light">
          <tr>
            <th scope="col">date</th>
            <th scope="col">map</th>
            <th scope="col">score</th>
            <th scope="col">accuracy</th>
          </tr>
        </thead>
        <tbody>
EOF
IFS=";"
jq -r '[.[]]|sort_by(.date)|.[]|"\(.date);\(.beatmap);\(.artist);\(.title);\(.mapper);\(.difficulty);\(.score);\(.accuracy)"' data/osu-daily.json \
|                         while read date mapid artist song mapper difficulty score accuracy
do cat >> _build/osu-daily.html << EOF
          <tr>
            <th scope="row">
              <a href="https://osu.ppy.sh/rankings/daily-challenge/$date"
                >$date</a
              >
            </th>
            <td><a href="https://osu.ppy.sh/b/$mapid">$artist - $song [$difficulty] ($mapper)</a></td>
            <td>$score</td>
            <td>$accuracy</td>
          </tr>
EOF
done
cat >> _build/osu-daily.html << EOF
        </tbody>
      </table>
    </main>
    I have not stopped playing the Daily Challenges (as of 2025-01-06), but the automatic update is currently broken.
  </body>
</html>
EOF

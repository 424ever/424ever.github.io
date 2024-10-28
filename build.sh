#!/bin/sh
rm -rfv _build
mkdir -pv _build

cp -rv static/* _build

# osu! daily
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
            <a href="osu-daily.html" aria-current="page">osu! daily challenges</a>
          </li>
        </ul>
      </nav>
    </header>

    <main class="container">
      <table><thead><tr>
      <th scope="col">date</th>
      <th scope="col">artist</th>
      <th scope="col">song</th>
      <th scope="col">mapper</th>
      <th scope="col">difficulty</th>
      <th scope="col">score</th>
      <th scope="col">accuracy</th>
      </tr></thead>
      <tbody>
EOF

IFS=";"
while read date artist song mapper difficulty score accuracy
  do
    cat >> _build/osu-daily.html << EOF
    <tr>
    <th scope="row">$date</th>
    <td>$artist</td>
    <td>$song</td>
    <td>$mapper</td>
    <td>$difficulty</td>
    <td>$score</td>
    <td>$accuracy</td>
    </tr>
EOF

  done < data/osu-daily.csv

cat >> _build/osu-daily.html << EOF
    </tbody></table>
    </main>
  </body>
</html>
EOF

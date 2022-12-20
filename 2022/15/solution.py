def line_intersect(ax1, ay1, ax2, ay2, bx1, by1, bx2, by2):
    if (d := (by2 - by1) * (ax2 - ax1) - (bx2 - bx1) * (ay2 - ay1)):
        if 0 <= (ua := ((bx2 - bx1) * (ay1 - by1) - (by2 - by1) * (ax1 - bx1)) / d) <= 1 \
        and 0 <= (ub := ((ax2 - ax1) * (ay1 - by1) - (ay2 - ay1) * (ax1 - bx1)) / d) <= 1:
            return int(ax1 + ua * (ax2 - ax1)), int(ay1 + ua * (ay2 - ay1))

def find(set_y=2000000):
    x_ranges = set()
    m, wn, ws, ne, se = [], [], [], [], []
    for sensor, beacon in data:
        m.append((manhattan := sum(abs(a - b) for a, b in zip(sensor, beacon))))
        wn.append(((w := (sensor[0] - manhattan - 1, sensor[1])), (n := (sensor[0], sensor[1] - manhattan - 1))))
        ws.append((w, (s := (sensor[0], sensor[1] + manhattan + 1))))
        ne.append((n, (e := (sensor[0] + manhattan + 1, sensor[1]))))
        se.append((s, e))
        if (man_y := abs(sensor[1] - set_y)) <= manhattan:
            x_ranges.add((sensor[0] - (man_x := manhattan - man_y), sensor[0] + man_x))
    start, end = min(x[0] for x in x_ranges), max(x[1] for x in x_ranges)
    return m, wn, ws, ne, se, abs(start - end) + 1 - sum(x[1] == set_y for x in beacons)

with open("input.txt", "r") as file:
    data = [((z := [int(x.split(" ")[y].split("=")[1].strip(",").strip(":")) for y in [2, 3, -2, -1]])[:2], z[2:]) for x in file.read().splitlines()]
    beacons = set(tuple(x[1]) for x in data)
    m, wn, ws, ne, se, p1 = find()
    points = set()
    p2 = None
    while not p2:
        for a, b in wn + se:
            for c, d in ws + ne:
                if (hit := line_intersect(*a, *b, *c, *d)) and 0 <= min(hit) and max(hit) <= 4000000:
                    for e, (sensor, beacon) in enumerate(data):
                        if sum(abs(a - b) for a, b in zip(sensor, hit)) <= m[e]:
                            break
                    else:
                        p2 = hit[0] * 4000000 + hit[1]
    print("day 15: ", p1, p2)
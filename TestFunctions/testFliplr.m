function test_suite = testFliplr
initTestSuite;
end

function testFliplrMatrix
in = magic(3);
assertEqual(fliplr(in), in(:, [3 2 1]));
end

function testFliplrVector
assertEqual(fliplr([1 4 10]), [10 4 1]);
end
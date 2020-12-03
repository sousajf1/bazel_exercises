#include "cstack.h"
#include "gtest/gtest.h"

TEST(RStack, PushPopTest)
{
  Stack r;
  r.push(1);
  r.push(2);
  r.push(3);

  EXPECT_EQ(r.pop(), 3);
  EXPECT_EQ(r.pop(), 2);
  EXPECT_EQ(r.pop(), 1);
}
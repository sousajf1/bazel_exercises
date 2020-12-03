#include "cstack.h"
#include "revstack.h"
#include "gtest/gtest.h"

TEST(RStack, PushPopTest)
{
  RevStack r;
  r.push(1);
  r.push(2);
  r.push(3);

  EXPECT_EQ(r.pop(), 3);
  EXPECT_EQ(r.pop(), 2);
  EXPECT_EQ(r.pop(), 1);
}

TEST(RStack, RevPushPopTest)
{
  RevStack r;
  r.push(1);
  r.push(2);
  r.push(3);
  r.reverse();

  EXPECT_EQ(r.pop(), 1);
  EXPECT_EQ(r.pop(), 2);
  EXPECT_EQ(r.pop(), 3);
}
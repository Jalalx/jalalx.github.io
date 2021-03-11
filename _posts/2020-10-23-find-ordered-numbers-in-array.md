---
layout: post
title: Find ordered numbers in an array — Programming Problem
categories: [ programming problem ]
description: "The Problem: Write a function that takes an array of numbers and returns the count of ordered numbers. By the way, all numbers are unique."
---

## The Problem
An **ordered** number in an array is the number that is greater than all numbers before itself and is smaller than all numbers after it.

For example in [1, 3, 2] number 1 is ordered because it's greater than all numbers before itself (no numbers!) and is smaller than all numbers after it.
By that definition, all members of [1, 2, 3] are ordered but there is no ordered number in [3, 2, 1].

Given that, Write a function that takes an array of numbers and returns the count of ordered numbers. By the way, all numbers are unique.


## The Solution
Okay!, let's break the problem into two parts:
First, we need to find all numbers that are greater than all numbers on their left side. The algorithm would be:

Consider a temporary variable `leftMax` and initialize it with the first member of the array. Also, consider a temporary list lefts that holds all numbers that are greater than their left side members. Since the first member of the array is greater than all numbers before itself (which is none!) add it to the lefts.
Start traversing from the second left member to right (because we already set the first member in the lefts!).

In each step, if the current element of the array is greater than the `leftMax` value, then update `leftMax` and add the current member to lefts list.
This will cost O(n) time and O(n) space complexity.

Let’s consider:

```
A = [1, 4, 3, 5]
```

In this example, when we move from left to right in array `A`, we keep track of the biggest value until now. Initially, `leftMax` is 1 and lefts is [1]. Loop starts and the second member, which is 4 is greater than the `leftMax` so `leftMax` becomes 4 and also we add 4 to lefts list. The next member 3 is smaller than `leftMax` and we ignore it. The last member is 5 and is greater than `leftMax` value, so `leftMax` becomes 5 and we add it to lefts which is [1, 4, 5] by now.

Second, we need to do exactly the opposite of what we did before: find all numbers that are smaller than all numbers on their right side! So the algorithm would be:
Again, consider a temporary variable `rightMin` and initialize it with the last member of the array. Also, consider a temporary list rights that holds all numbers that are smaller than their right side members. Since the last member of the array is smaller than all numbers after itself (which is none!) add it to the rights. Start traversing from the second to last member to left (as you know, we already set the last member in the rights!).

In each step, if the current element of the array is smaller than the `rightMin` value, then update `rightMax` and add the current member to rights list.
Same as above, this also will cost O(n) time and O(n) space complexity.

In the example above, when we move from right to left in array `A`, we keep track of the smallest value until now. In the beginning, `rightMin` is 5 and rights is [5]. Loop starts and the next member, which is 3 is smaller than the `rightMin` so `rightMin` becomes 3 and also we add 3 to rights list. The next member 4 is smaller than `rightMin` and we ignore it. The last member is 1 and is smaller than `rightMin` value, so `rightMin` becomes 1 and we add it to rights which becomes [5, 3, 1].

Well, what does lefts and rights have in common?

```
[1, 4, 5] ∩ [5, 3, 1] = [1, 5]
```

Yes! that’s the answer! [1, 5] are ordered numbers in the array `A`.
But how do you find the intersection of two arrays? Hum?

Using a Hash Table data structure can help with this because they have O(1) access time and make the intersection algorithm much simpler to implement.

At first, we add all numbers of the first array to the hash table. Then, in a loop in the second array, check if the current number exists in the hash table that means it exists on both arrays.

Here is the implementation in C#:

```csharp
/*
mkdir OrderedNumbers
cd ./OrderedNumbers 
dotnet new xunit
*/ 

using System;
using System.Collections.Generic;
using System.Linq;
using Xunit;

namespace OrderedNumbers
{
    public class OrderedNumbersTests
    {
        public static int GetOrderedNumbersCount(int[] numbers, int n)
        {
            if (n == 0 || n == 1)
            {
                return n;
            }

            var lefts = new List<int>();
            var leftMax = numbers[0];
            lefts.Add(numbers[0]);

            for (int i = 1; i < n; i++)
            {
                if (numbers[i] > leftMax)
                {
                    lefts.Add(numbers[i]);
                    leftMax = numbers[i];
                }
            }

            var rights = new List<int>();
            var rightMin = numbers[n - 1];
            rights.Add(numbers[n - 1]);

            for (int i = n - 2; i >= 0; i--)
            {
                if (numbers[i] < rightMin)
                {
                    rights.Add(numbers[i]);
                    rightMin = numbers[i];
                }
            }

            var count = 0;
            var hashSetLefts = new HashSet<int>(lefts);
            foreach (var right in rights)
            {
                if (hashSetLefts.Contains(right))
                {
                    count++;
                }
            }
            //var count = rights.Intersect(lefts).Count();
            return count;
        }

        [Fact]
        public static void ForBasic_Pass()
        {
            // Arrange
            var numbers = new int[] { 1, 2, 3 };

            // Act
            var actual = GetOrderedNumbersCount(numbers, numbers.Length);

            // Assert
            Assert.Equal(3, actual);
        }

        [Fact]
        public static void ForSingle_Pass()
        {
            // Arrange
            var numbers = new int[] { 1 };

            // Act
            var actual = GetOrderedNumbersCount(numbers, numbers.Length);

            // Assert
            Assert.Equal(1, actual);
        }

        [Fact]
        public static void ForEmpty_Pass()
        {
            // Arrange
            var numbers = new int[] { };

            // Act
            var actual = GetOrderedNumbersCount(numbers, numbers.Length);

            // Assert
            Assert.Equal(0, actual);
        }

        [Fact]
        public static void ForReverseArray_Pass()
        {
            // Arrange
            var numbers = new int[] { 5, 4, 3, 2, 1 };

            // Act
            var actual = GetOrderedNumbersCount(numbers, numbers.Length);

            // Assert
            Assert.Equal(0, actual);
        }

        [Fact]
        public static void ForUnOrderedArray_Pass()
        {
            // Arrange
            var numbers = new int[] { 54, 45, 37, 22, 10, 69, 95, 82, 71 };

            // Act
            var actual = GetOrderedNumbersCount(numbers, numbers.Length);

            // Assert
            Assert.Equal(1, actual);
        }
    }
}
```

Have a great day!
defmodule Chat.BucketTest do
  # run mutiple specs with async at once (over multiple cores)
  # dont use if specing global things
  use ExUnit.Case, async: true

  setup do
    {:ok, bucket} = start_supervised(Chat.Bucket)
    %{bucket: bucket}
  end

  test "stores values by key", %{bucket: bucket} do
    assert Chat.Bucket.get(bucket, "Alexander") == nil

    Chat.Bucket.put(bucket, "Alexander", "Test")
    assert Chat.Bucket.get(bucket, "Alexander") == "Test"

    Chat.Bucket.delete(bucket, "Alexander")
    assert Chat.Bucket.get(bucket, "Alexander") == nil
  end

  test "are temporary workers" do
    assert Supervisor.child_spec(Chat.Bucket, []).restart == :temporary
  end
end

defmodule Chat.RegistryTest do
  use ExUnit.Case, async: true

  setup context do
    {:ok, registry} = start_supervised({Chat.Registry, name: context.test})
    %{registry: registry}
  end

  test "spawns buckets", %{registry: registry} do
    assert Chat.Registry.lookup(registry, "messages") == :error

    Chat.Registry.create(registry, "messages")
    assert {:ok, bucket} = Chat.Registry.lookup(registry, "messages")

    Chat.Bucket.put(bucket, "Alexander", "Hallo Welt!")
    assert Chat.Bucket.get(bucket, "Alexander") == "Hallo Welt!"
  end

  test "removes buckets on exit", %{registry: registry} do
    Chat.Registry.create(registry, "messages")
    {:ok, bucket} = Chat.Registry.lookup(registry, "messages")
    Agent.stop(bucket)

    _ = Chat.Registry.create(registry, "other")
    assert Chat.Registry.lookup(registry, "messages") == :error
  end

  test "removes bucket on crash", %{registry: registry} do
    Chat.Registry.create(registry, "messages")
    {:ok, bucket} = Chat.Registry.lookup(registry, "messages")

    # stop the bucket with non-normal reason
    Agent.stop(bucket, :shutdown)

    _ = Chat.Registry.create(registry, "other")
    assert Chat.Registry.lookup(registry, "messages") == :error
  end
end

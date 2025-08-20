import { GalleryVerticalEnd } from "lucide-react";

import { cn } from "@/lib/utils";
import { Button } from "@/components/ui/button";
import { Input } from "@/components/ui/input";
import { Label } from "@/components/ui/label";
import { useForm } from "@inertiajs/react";
import { user_registration_path } from "@/routes";

export function RegistrationForm({
  className,
  ...props
}: React.ComponentProps<"div">) {
  const { post, data, setData, processing } = useForm({
    user: { email: "", password: "", password_confirmation: "" },
  });

  function loginUser(e: React.FormEvent<HTMLFormElement>) {
    e.preventDefault();
    e.stopPropagation();

    post(user_registration_path());
  }

  return (
    <div className={cn("flex flex-col gap-6", className)} {...props}>
      <form onSubmit={loginUser}>
        <div className="flex flex-col gap-6">
          <div className="flex flex-col items-center gap-2">
            <a
              href="#"
              className="flex flex-col items-center gap-2 font-medium"
            >
              <div className="flex size-8 items-center justify-center rounded-md">
                <GalleryVerticalEnd className="size-6" />
              </div>
              <span className="sr-only">Acme Inc.</span>
            </a>
            <h1 className="text-xl font-bold">Welcome to Acme Inc.</h1>
            <div className="text-center text-sm">
              Already have an account?{" "}
              <a href="/users/sign_in" className="underline underline-offset-4">
                Sign in
              </a>
            </div>
          </div>
          <div className="flex flex-col gap-6">
            <div className="grid gap-3">
              <Label htmlFor="email">Email</Label>
              <Input
                id="email"
                type="email"
                placeholder="m@example.com"
                required
                onChange={(e) =>
                  setData("user", { ...data.user, email: e.target.value })
                }
              />
            </div>
            <div className="grid gap-3">
              <Label htmlFor="password">Password</Label>
              <Input
                id="password"
                type="password"
                placeholder="********"
                required
                onChange={(e) =>
                  setData("user", { ...data.user, password: e.target.value })
                }
              />
            </div>
            <div className="grid gap-3">
              <Label htmlFor="password_confirmation">
                Confirm your password
              </Label>
              <Input
                id="password_confirmation"
                type="password"
                placeholder="********"
                required
                onChange={(e) =>
                  setData("user", {
                    ...data.user,
                    password_confirmation: e.target.value,
                  })
                }
              />
            </div>
            <Button className="w-full" disabled={processing}>
              Login
            </Button>
          </div>
        </div>
      </form>
      <div className="text-muted-foreground *:[a]:hover:text-primary text-center text-xs text-balance *:[a]:underline *:[a]:underline-offset-4">
        By clicking continue, you agree to our <a href="#">Terms of Service</a>{" "}
        and <a href="#">Privacy Policy</a>.
      </div>
    </div>
  );
}
